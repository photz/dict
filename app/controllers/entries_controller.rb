class EntriesController < ApplicationController

  before_filter :restrict_access
  before_action :set_entry, only: [:show, :edit, :update, :destroy]
  before_action :set_dictionary, except: [:edit, :update]

  # GET /entries/1
  def show
    root_path unless current_user.can_view_dictionary(@entry.dictionary)
  end

  # GET /entries/new
  def new
    @entry = Entry.new
  end

  # GET /entries/1/edit
  def edit
    root_path unless current_user.can_change_entries(@dictionary)
  end

  # POST /entries
  def create
    root_path unless current_user.can_create_entries(@dictionary)

    @entry = Entry.new(entry_params)

    lemmata_strings = params[:entry][:lemmata]
                      .strip.split("\n").map {|s| s.strip}

    @entry.lemmata = lemmata_strings

    @entry.dictionary = @dictionary

    respond_to do |format|
      if @entry.save
        format.html { redirect_to @entry, notice: 'Entry was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /entries/1
  def update
    root_path unless current_user.can_change_entries(@dictionary)

    lemmata_strings = params[:entry][:lemmata]
                      .strip.split("\n").map {|s| s.strip}

    @entry.lemmata = lemmata_strings

    logger.info "lemmata: " + @entry.lemmata.to_s

    respond_to do |format|
      if @entry.update(entry_params)
        format.html { redirect_to @entry, notice: 'Entry was successfully updated.' }

      else
        format.html { render :edit }

      end
    end
  end

  # DELETE /entries/1
  def destroy
    root_path unless current_user.can_delete_entries(@dictionary)

    @entry.destroy
    respond_to do |format|
      format.html { redirect_to @dictionary, notice: 'Entry was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find_by_id(params[:id])
    end

    def set_dictionary
      @dictionary = Dictionary.find_by_id(params[:dictionary_id])
      if @dictionary.nil?
        @dictionary = @entry.dictionary
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:content)
    end

    def restrict_access
      unless logged_in
        redirect_to login_path
      end
    end


end
