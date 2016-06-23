class Dictionary < ActiveRecord::Base
  has_many :entries

  has_many :collaborators

  has_many :users, through: :collaborators

  belongs_to :user

  validates :name,
            presence: true,
            length: { minimum: 3, maximum: 50 }

  validates :user,
            presence: true

  accepts_nested_attributes_for :collaborators, update_only: true

end
