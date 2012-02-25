class District < ActiveRecord::Base
  has_many :sub_counties
  has_many :health_sub_districts
  has_many :venues
  has_one :district_data, :as => :populated_location
  belongs_to :region
 
  scope :by_name, order('name ASC')

  include Location

  def children
    self.sub_counties
  end

  def congregations
    Congregation.where(['health_unit_id',
      HealthUnit.where(['parish_id IN (?)',
        Parish.where(['sub_county IN (?)',
          SubCounty.where(['health_sub_district_id IN (?)',
            HealthSubDistrict.where(['district_id = ?', self.id]).map {|x| x.id}
          ]).map {|x| x.id}
        ]).map {|x| x.id}
      ]).map {|x| x.id}
    ])
  end
end
