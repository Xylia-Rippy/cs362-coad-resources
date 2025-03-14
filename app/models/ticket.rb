/
my thoughts on this
sets the region where the ticket is
sets what category is needed 
finds if part of a organization

makes sure there is name, phone, region id, and what category it is.
validates lenght of name has a min number of char that is 1 with a max of 255
validates lenght of description has a max number of char is 1020
sees if a vaild phone number is there

It is a ticket that holds the information of a emergemcy and what assestance is needed. 

/
class Ticket < ApplicationRecord

  belongs_to :region
  belongs_to :resource_category
  belongs_to :organization, optional: true

  validates_presence_of :name, :phone, :region_id, :resource_category_id
  validates_length_of :name, minimum: 1, maximum: 255, on: :create
  validates_length_of :description, maximum: 1020, on: :create
  validates :phone, phony_plausible: true

  scope :open, -> () { where closed: false, organization_id: nil }
  scope :closed, -> () { where closed: true }
  scope :all_organization, -> () { where(closed: false).where.not(organization_id: nil) }
  scope :organization, -> (organization_id) { where(organization_id: organization_id, closed: false) }
  scope :closed_organization, -> (organization_id) { where(organization_id: organization_id, closed: true) }
  scope :region, -> (region_id) { where(region_id: region_id) }
  scope :resource_category, -> (resource_category_id) { where(resource_category_id: resource_category_id) }


  def open?
    !closed
  end

  def captured?
    organization.present?
  end

  def to_s
    "Ticket #{id}"
  end

end
