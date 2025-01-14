class Organization < ApplicationRecord

  # Terms and conditions being pulled from the accessor.
  attr_accessor :agreement_one, :agreement_two, :agreement_three, :agreement_four, :agreement_five, :agreement_six, :agreement_seven, :agreement_eight

  # The status is set to a specific section as provided in the code.
  enum status: [:approved, :submitted, :rejected, :locked]
  # This defines whether the object of transportation is a yes, no or a maybe.
  enum transportation: [:yes, :no, :maybe]

  # Sets the defult status if it's a newer record. 
  after_initialize :set_default_status, :if => :new_record?

  # Claims that the Organization can have many users.
  has_many :users
  # Claims that the Organization can have many tickets.
  has_many :tickets
  # This states that a Organization can be inside or "claim" multiple resource_categories inside the system.
  # In short it can belong to a specific categorie or can contain a dfferent categorie.
  # eg: Red Cross contains the Medical categorie, and the Snow Plow CP company belongs to the Snow Plowing categorie.
  has_and_belongs_to_many :resource_categories

  # Checks to see the emails of the Organization and to see if it follows the required specifications.
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  # Validates if the Organization has a phone, email, name, etc.
  validates_presence_of :email, :name, :phone, :status, :primary_name, :secondary_name, :secondary_phone
  validates_length_of :email, minimum: 1, maximum: 255, on: :create
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates_uniqueness_of :email, case_sensitive: false
  validates_length_of :name, minimum: 1, maximum: 255, on: :create
  validates_uniqueness_of :name, case_sensitive: false
  validates_length_of :description, maximum: 1020, on: :create

  def approve
    self.status = :approved
  end

  def reject
    self.status = :rejected
  end

  def set_default_status
    self.status ||= :submitted
  end

  def to_s
    name
  end

end