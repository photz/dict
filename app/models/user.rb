class User < ActiveRecord::Base

  validates :name,
            presence: true,
            length: { minimum: 3, maximum: 30 },
            uniqueness: { case_sensitive: false }

  has_secure_password

  validates :password,
            presence: true,
            length: { minimum: 6 }

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
