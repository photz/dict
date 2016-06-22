class AddPublicToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :public, :boolean
  end
end
