/
This is the region class it inherits data from ApplicationRecord
This class checks the number of letters in the ticket min words 1, max words 255
This class checks the amount of tickets
This class checks the copy of same city
If not def create new region
I currently do not know what to_s

region holds the region names and making a name if one is not found

/
class Region < ApplicationRecord

  has_many :tickets

  validates_presence_of :name
  validates_length_of :name, minimum: 1, maximum: 255, on: :create
  validates_uniqueness_of :name, case_sensitive: false

  def self.unspecified
    Region.find_or_create_by(name: 'Unspecified')
  end

  def to_s
    name
  end

end
