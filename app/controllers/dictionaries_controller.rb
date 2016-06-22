class DictionariesController < ApplicationController
  before_filter :restrict_access

  before_action :set_dictionary, only: [:show, :edit, :update, :destroy]

  # GET /dictionaries
  def index
    @dictionaries = Dictionary.where(public: true)
  end

  # GET /dictionaries/1
  def show
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

  end

  # POST /dictionaries
  def create
    @dictionary = Dictionary.new(dictionary_params)

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
      params.require(:dictionary).permit(:name, :description, :public)
    end

    def restrict_access
      unless logged_in
        redirect_to login_path
      end
    end
end
