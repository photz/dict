class AddEntriesLemmas < ActiveRecord::Migration
  def change
    create_table :entries_lemmas, :id => false do |t|
      t.references :entry
      t.references :lemma
    end
  end
end
