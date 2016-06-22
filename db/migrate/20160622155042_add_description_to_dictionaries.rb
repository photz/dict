class AddDescriptionToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :description, :string
  end
end
