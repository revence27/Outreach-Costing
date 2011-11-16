require 'functions'

class Assumption < ActiveRecord::Base
  scope :ordered, order('created_at ASC')

  validates_each :label do |model, attr, val|
    unless Functions.respond_to? val then
      model.errors << %[there is no formula called #{val}]
    end
  end
end
