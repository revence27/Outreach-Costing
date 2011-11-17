class Activity < ActiveRecord::Base
  belongs_to :component
  has_many   :activity_items

  def chosen_items them
    if them.is_a? Hash then
      chosen_items them['selection'][self.id.to_s]
    else
      self.activity_items.where ['id IN (?)', them]
    end
  end
end
