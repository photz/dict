class CreateLemmas < ActiveRecord::Migration
  def change
    create_table :lemmas do |t|
      t.belongs_to :entry, index: true, foreign_key: true
      t.string :text

      t.timestamps null: false
    end
  end
end
