class AddUserIdToDictionary < ActiveRecord::Migration
  def change
    add_reference :dictionaries, :user, index: true
  end
end
