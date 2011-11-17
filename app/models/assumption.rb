class Assumption < ActiveRecord::Base
  belongs_to :activity

  scope :ordered, order('created_at ASC')

  validates_each :label do |model, attr, val|
    unless Functions.respond_to? val then
      model.errors.add attr, %[there is no formula called #{val}]
    end
  end

  def self.exec lbl, *args
    self.find_by_label(lbl).calculate *args
  end

  def calculate *args
    Functions.send self.label, self, *args
  end
end
