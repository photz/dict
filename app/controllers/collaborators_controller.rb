class CollaboratorsController < ApplicationController
  before_filter :set_dictionary

  def create

    user = User.find_by(name: params[:name])

    if user.nil?
      assert 'no such user'
    end

    if user == @dictionary.user
      assert 'the owner of a dictionary cannot become a collaborator'
    end

    if @dictionary.users.include? user
      assert 'the user already is a collaborator'
    end
    
    collaborator = Collaborator.new

    collaborator.dictionary = @dictionary
    collaborator.user = user

    collaborator.save!

    redirect_to edit_dictionary_path(@dictionary)

  end

  def destroy
    user = User.find_by_id(params[:id])

    
  end

  private

  def set_dictionary
    @dictionary = Dictionary.find_by_id(params[:dictionary_id])
  end
end
