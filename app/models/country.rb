class Country < ActiveRecord::Base
  has_many :regions

  scope :by_name, self.order('name ASC')

  include Location

  def children
    self.regions
  end
end
