class SubCounty < ActiveRecord::Base
  has_many :parishes
  belongs_to :district

  scope :by_name, order('name ASC')

  include Location

  def children
    self.parishes
  end
end
