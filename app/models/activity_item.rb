class ActivityItem < ActiveRecord::Base
  belongs_to :activity
  has_many   :assumptions

  def assumption component, section
    self.assumptions.find_by_category component
  end
end
