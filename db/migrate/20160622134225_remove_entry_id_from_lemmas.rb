class RemoveEntryIdFromLemmas < ActiveRecord::Migration
  def change
    remove_column :lemmas, :entry_id
  end
end
