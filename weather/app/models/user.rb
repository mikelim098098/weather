class User < ActiveRecord::Base
  PHONE_REGEX = /\A(\d{10}|\(?\d{3}\)?[-. ]\d{3}[-.]\d{4})\z/
  has_secure_password
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, format: { with: PHONE_REGEX }
  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }
end
