class Entry < ActiveRecord::Base
  attr_accessor :lemmata

  before_validation :initialize_lemmata

  belongs_to :dictionary

  has_and_belongs_to_many :lemmas, -> { uniq }

  validates :lemmas,
            presence: true

  validates :dictionary,
            presence: true

  accepts_nested_attributes_for :lemmas

  def lemmata
    @new_lemmata_str || self.lemmas.map {|l| l.text}
  end

  def lemmata=(strings)
    @new_lemmata_str = strings
  end

  def initialize_lemmata

    add = @new_lemmata_str - self.lemmas.map {|l| l.text}

    self.lemmas.each do |lemma|
      unless @new_lemmata_str.include? lemma.text
        self.lemmas.delete lemma
      end
    end

    add.each do |new_lemma_str|
      self.lemmas.append(Lemma.find_or_initialize_by(text: new_lemma_str))
      logger.debug 'before save adding ' + new_lemma_str
    end

    
  end

end
