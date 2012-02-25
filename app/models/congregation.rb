class Congregation < ActiveRecord::Base
  belongs_to  :health_unit
  has_one     :demographics, :as => :populated_location
end
