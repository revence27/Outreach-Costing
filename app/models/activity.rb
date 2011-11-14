class Activity < ActiveRecord::Base
  belongs_to :component
  has_many   :activity_items
end
