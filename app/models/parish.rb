class Parish < ActiveRecord::Base
  has_many :villages
  belongs_to :sub_county

  scope :by_name, order('name ASC')

  include Location

  def children
    self.villages
  end
end
