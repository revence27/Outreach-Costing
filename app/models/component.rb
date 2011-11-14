class Component < ActiveRecord::Base
  has_many :activities

  scope :by_name, order('name ASC')
end
