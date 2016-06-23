class DictionariesController < ApplicationController
  before_filter :restrict_access

  before_action :set_dictionary, only: [:show, :edit, :update, :destroy]

  # GET /dictionaries
  def index
    @dictionaries = Dictionary.where(public: true)
  end

  # GET /dictionaries/1
  def show

    root_path unless current_user.can_view_dictionary(@dictionary)

    respond_to do |format|

      format.html

      format.babylon { render 'dictionaries/show.babylon.erb',
                              layout: false,
                              content_type: 'text/plain' }

      format.xdxf { render 'dictionaries/show.xdxf.erb',
                           layout: false,
                           content_type: 'text/xml' }
    end    
  end

  # GET /dictionaries/new
  def new
    @dictionary = Dictionary.new
  end

  # GET /dictionaries/1/edit
  def edit
    redirect_to root_path unless @dictionary.user == current_user

  end

  # POST /dictionaries
  def create
    redirect_to root_path unless @dictionary.user == current_user


    @dictionary = Dictionary.new(dictionary_params)

    @dictionary.user = current_user

    respond_to do |format|
      if @dictionary.save
        format.html { redirect_to @dictionary, notice: 'Dictionary was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /dictionaries/1
  def update
    redirect_to root_path unless @dictionary.user == current_user

    respond_to do |format|
      if @dictionary.update(dictionary_params)
        format.html { redirect_to @dictionary, notice: 'Dictionary was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /dictionaries/1
  def destroy
    redirect_to root_path unless @dictionary.user == current_user

    @dictionary.destroy
    respond_to do |format|
      format.html { redirect_to dictionaries_url, notice: 'Dictionary was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dictionary
      @dictionary = Dictionary.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dictionary_params
      params
        .require(:dictionary)
        .permit(:name, :description, :public,
                collaborators_attributes: [:user_id,
                                           :id,
                                           :can_create_entries,
                                           :can_change_entries,
                                           :can_delete_entries])
    end

    def restrict_access
      unless logged_in
        redirect_to login_path
      end
    end
end
