class User < ApplicationRecord

  # Validations
  validates :account_key,  uniqueness: true
  validates :email,        presence: true, uniqueness: true
  validates :key,          presence: true, uniqueness: true
  validates :password,     presence: true
  validates :phone_number, presence: true, uniqueness: true

  # Scopes
  default_scope -> { order(created_at: :desc) }
end
