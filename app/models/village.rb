class Village < ActiveRecord::Base
  belongs_to :parish
  has_many   :villages

  scope :by_name, scope('name ASC')

  include Location

  def children
    []
  end
end
