class User < ApplicationRecord

  # Validations
  validates :account_key,  uniqueness: true
  validates :email,        presence: true, uniqueness: true
  validates :key,          presence: true, uniqueness: true
  validates :password,     presence: true
  validates :phone_number, presence: true, uniqueness: true

  # Scopes
  default_scope -> { order(created_at: :desc) }
  scope :by_metadata, -> (key) { where('metadata ilike ?', "%#{key}%") }

  # Callbacks
  before_validation :generate_key

  # Re-defining the setter method in password to make the hasing+salt procedure
  # more transparent
  def password=(value)
    encrypted_passsword = Digest::MD5.hexdigest("#{value}#{Rails.env['PASSWORD_SALT']}")
    self.write_attribute(:password, encrypted_passsword)
  end

  private

  def generate_key
    self.key = SecureRandom.hex(64)
  end
end
