class User < ActiveRecord::Base
  has_secure_password
  has_many :alerts, dependent: :destroy

  PHONE_REGEX = /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, format: { with: PHONE_REGEX }
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }

end
