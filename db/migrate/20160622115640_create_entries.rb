class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.belongs_to :dictionary, index: true, foreign_key: true
      t.string :content

      t.timestamps null: false
    end
  end
end
