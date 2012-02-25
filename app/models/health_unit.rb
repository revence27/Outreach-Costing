class HealthUnit < ActiveRecord::Base
  belongs_to  :parish
  has_many    :congregations

  include Location

  def children
    self.congregations
  end
end
