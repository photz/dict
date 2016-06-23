class CreateCollaborators < ActiveRecord::Migration
  def change
    create_table :collaborators do |t|
      t.references :user, index: true, foreign_key: true
      t.references :dictionary, index: true, foreign_key: true
      t.boolean :can_create_entries
      t.boolean :can_change_entries
      t.boolean :can_delete_entries

      t.timestamps null: false
    end
  end
end
