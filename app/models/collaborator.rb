class Collaborator < ActiveRecord::Base
  after_initialize :set_defaults, unless: :persisted?

  belongs_to :user
  belongs_to :dictionary

  validates :user,
            presence: true

  validates :dictionary,
            presence: true

  #validates :can_create_entries, presence: true
  #validates :can_change_entries, presence: true
  #validates :can_delete_entries, presence: true

  validates :user_id, uniqueness: { scope: [:dictionary_id] }


  # The set_defaults will only work if the object is new

  def set_defaults
    self.can_create_entries = false if self.can_create_entries.nil?
    self.can_change_entries = false if self.can_change_entries.nil?
    self.can_delete_entries = false if self.can_delete_entries.nil?
  end
end
