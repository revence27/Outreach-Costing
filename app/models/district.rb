class District < ActiveRecord::Base
  has_many :sub_counties
  has_many :health_sub_districts
  has_many :venues
  has_one :district_data, :as => :populated_location
  belongs_to :region
 
  scope :by_name, order('name ASC')

  include Location

  def children
    self.sub_counties
  end
end
