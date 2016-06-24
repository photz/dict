class RecordingsController < ApplicationController
  before_action :set_entry, only: [:create, :index]
  protect_from_forgery except: [:create, :index]


  def create

    unless current_user.can_change_entries(@entry.dictionary)
      logger.warning 'a user who is not allowed to change entries tried to upload a recording'

      render :status => 400
      return
    end

    directory = Rails.root.join('public', 'uploads')

    unless params.has_key? :audio_file
      logger.warning 'recordings#create called, but no file was found'

      render :status => 503
      return
    end

    uploaded_io = params[:audio_file]

    unless uploaded_io.class == ActionDispatch::Http::UploadedFile
      render :status => 503
      return
    end

    recording = Recording.new(entry: @entry, user: current_user)
    unless recording.save
      raise 'unable to save recording' + debug(recording.errors)
      render :status => 503
    end

    filepath = Rails.root.join(directory, recording.id.to_s + '.ogg')

    begin
      File.open(filepath, 'wb') do |file|
        file.write(uploaded_io.read)
      end
    rescue StandardError => e

      logger.error 'unable to store uploaded file locally'

      render :status => 503
      return
    end

    logger.info 'new audio file uploaded: ' + recording.id.to_s

    render :json => {
             status: 1,
             recording: {
               id: recording.id,
               user_id: recording.user_id,
               user_name: recording.user.name
             }
           }      

  end

  private

  def set_entry
    @entry = Entry.find_by_id(params[:entry_id])
  end

end
