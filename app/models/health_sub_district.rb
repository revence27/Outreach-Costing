class HealthSubDistrict < ActiveRecord::Base
  belongs_to  :district
  has_many    :sub_counties

  include Location

  def children
    self.sub_counties
  end
end
