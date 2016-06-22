class Lemma < ActiveRecord::Base
  has_and_belongs_to_many :entries, -> { uniq }

  validates :text,
            presence: true,
            length: { minimum: 2, maximum: 100 },
            uniqueness: true
end
