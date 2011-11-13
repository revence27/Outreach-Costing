class Region < ActiveRecord::Base
  belongs_to :country
  has_many :districts

  scope :by_name, order('name ASC')

  include Location

  def children
    self.districts
  end
end
