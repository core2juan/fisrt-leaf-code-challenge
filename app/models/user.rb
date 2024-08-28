class User < ApplicationRecord

  # Validations
  validates :account_key,   length: { maximum: 100 }, uniqueness: true, if: Proc.new { |user| user.account_key.present? }
  validates :email,         length: { maximum: 200 }, presence: true, uniqueness: true
  validates :full_name,     length: { maximum: 200 }
  validates :key,           length: { maximum: 100 }, presence: true, uniqueness: true
  validates :password,      length: { maximum: 100 }, presence: true
  validates :phone_number,  length: { maximum: 20 },  presence: true, uniqueness: true

  # Scopes
  default_scope -> { order(created_at: :desc) }
  scope :by_metadata, -> (key) { where('metadata ilike ?', "%#{key}%") }

  # Callbacks
  before_validation :generate_key
  after_create      :request_account_key

  # Re-defining the setter method in password to make the hasing+salt procedure
  # more transparent
  def password=(value)
    encrypted_passsword = Digest::MD5.hexdigest("#{value}#{Rails.env['PASSWORD_SALT']}")
    self.write_attribute(:password, encrypted_passsword)
  end

  private

  def generate_key
    self.key = SecureRandom.hex(32)
  end

  def request_account_key
    AccountKeyRequestWorker.perform_async(self.id)
  end
end
