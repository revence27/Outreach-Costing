class DistrictData < ActiveRecord::Base
  belongs_to :populated_location, :polymorphic => true
end
