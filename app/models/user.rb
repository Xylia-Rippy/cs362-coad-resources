# User Model
# This model handles user data, authentication, and role management. 
# - Users can have roles (:admin or :organization) with a default role of :organization.
# - Includes authentication features using Devise (e.g., login, registration, password recovery).
# - Validates email and password for proper format, length, and uniqueness.
# - Users can optionally belong to an organization.
# - Overrides `to_s` to return the user's email as a string representation.

class User < ApplicationRecord

  enum role: [:admin, :organization]
  after_initialize :set_default_role, :if => :new_record?

  belongs_to :organization, optional: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates_presence_of :email
  validates_length_of :email, minimum: 1, maximum: 255, on: :create
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive: false
  validates_presence_of :password, on: :create
  validates_length_of :password, minimum: 7, maximum: 255, on: :create

  def set_default_role
    self.role ||= :organization
  end

  def to_s
    email
  end

end
