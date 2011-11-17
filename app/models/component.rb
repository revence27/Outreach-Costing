class Component < ActiveRecord::Base
  has_many :activities

  scope :by_name, order('name ASC')

  def chosen_activities them
    if them.is_a? Hash then
      chosen_activities them['selection'].keys
    else
      self.activities.where ['id IN (?)', them]
    end
  end
end
