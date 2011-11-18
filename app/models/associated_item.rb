class AssociatedItem < ActiveRecord::Base
  belongs_to :activity_item
  has_many   :item_assumptions

  def assumption component, partition
    self.assumptions.where(:category => component, :section => partition).first
  end
end
