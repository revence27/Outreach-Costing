class ActivityItem < ActiveRecord::Base
  belongs_to :activity
  has_many   :assumptions
  has_many   :associated_items

  def assumption component, partition
    ans = self.assumptions.where(:category => component, :section => partition).first
    unless ans then
      self.assumptions.where(:category => component, :section => :vacc).first
    else
      ans
    end
  end
end
