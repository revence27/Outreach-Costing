class ItemAssumption < ActiveRecord::Base
  belongs_to :associated_item

  scope :ordered, order('created_at ASC')

  validates_each :label do |model, attr, val|
    unless val.nil? then
      unless Functions.respond_to? val then
        model.errors.add attr, %[there is no formula called #{val}]
      end
    end
  end

  def self.exec lbl, *args
    self.find_by_label(lbl).calculate *args
  end

  def calculate *args
    Functions.send(self.label || self.associated_item.name, self, *args)
  end
end
