class CollaboratorsController < ApplicationController
  before_filter :set_dictionary
  before_filter :is_owner

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

    if user.nil?
      assert 'no user found'
    end

    unless @dictionary.users.include? user
      assert 'the user specified is not a collaborator'
    end

    @dictionary.users.delete user
  end

  private

  def set_dictionary
    @dictionary = Dictionary.find_by_id(params[:dictionary_id])
  end

  def is_owner
    unless @dictionary.user == current_user
      logger.warn 'someone other than the owner of a dictionary tried to add or remove a collaborator'
      redirect_to root_path
    end
  end
end
