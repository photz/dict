class User < ActiveRecord::Base

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX }

  validates :name,
            presence: true,
            length: { minimum: 3, maximum: 30 },
            uniqueness: { case_sensitive: false }

  validates :password,
            presence: true,
            length: { minimum: 6 }

  has_many :dictionaries

  has_secure_password


  def can_view_dictionary(dictionary)


    return true if dictionary.user == self

    return true if dictionary.public

    collaborator = Collaborator.find_by(dictionary: dictionary,
                                        user: self)

    !collaborator.nil?
  end

  def can_create_entries(dictionary)
    return true if dictionary.user == self

    collaborator = Collaborator.find_by(dictionary: dictionary,
                                        user: self)

    collaborator && collaborator.can_create_entries
  end

  def can_change_entries(dictionary)
    unless dictionary.class.to_s === 'Dictionary'
      raise 'must provide a dictionary, got ' + dictionary.class.to_s
    end

    return true if dictionary.user == self

    collaborator = Collaborator.find_by(dictionary: dictionary,
                                        user: self)

    collaborator && collaborator.can_change_entries
  end

  def can_delete_entries(dictionary)
    return true if dictionary.user == self

    collaborator = Collaborator.find_by(dictionary: dictionary,
                                        user: self)

    collaborator && collaborator.can_delete_entries
  end

  def authenticated?(remember_token)
    return false if rememmber_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def remember
    self.remember_token = 0
    update_attribute(:remember_digest, 0)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end
end
