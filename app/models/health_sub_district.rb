class HealthSubDistrict < ActiveRecord::Base
  belongs_to  :district
  has_one :district_data, :as => :populated_location
end
