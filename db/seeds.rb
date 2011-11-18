user = User.create(
  [{:username => 'revence', :is_admin => false, :sha1_salt => 'mwahaha', :sha1_pass => 'e643004bb0ad15b6fd350c641f78cb10d46132f5'},
   {:username => 'sharad', :is_admin => true,   :sha1_salt => 'hehehe',  :sha1_pass => '215822e8636cc2aaa8223147d823f02e4344550c'}])

# Geography

ug = Country.create :name => 'Uganda'

File.open(ENV['REGION_DATA'] || %[doc/regiondata.tsv]) do |rd|
  rd.each_line do |ligne|
    reg, dst, tot, u1, a14, prg = ligne.strip.split(/\s*\t\s*/)
    region    = Region.find_by_name reg
    unless region then
      region    = Region.create :name => reg
      region.save
    end
    district  = District.create :name => dst
    begin
      district.district_data = DistrictData.create(
              :population  => tot.gsub(/\D/, '').to_i,
              :under_one   => u1.gsub(/\D/, '').to_i,
              :one_to_four => a14.gsub(/\D/, '').to_i,
              :pregnancies => prg.gsub(/\D/, '').to_i)
    rescue Exception => e
      raise Exception.new(e.message + %[ on #{ligne.inspect}])
    end
    region.districts << district
    ug.regions << region
  end
end

# Components

proc do |them|
  them.each do |it|
    component = Component.create :name => it.first
    it.last.each do |act|
      activity  = Activity.create  :name => act.first
      act.last.each do |item|
        ah = ActivityItem.create(:name => item[1] || item.first.downcase.gsub(/[^a-z]/, ''), :description => item.first)
        ah.assumptions << (item[2].is_a?(Assumption) ? item[2] : Assumption.create(:category => component.name, :label => ah.name, :value => (item[2] ? item[2].to_f :  nil)))
        unless ah.valid? then
          raise Exception.new(ah.errors.inspect)
        end
        activity.activity_items << ah
      end
      component.activities << activity
    end
    component.save
  end
end.call([
[
  'PMTCT',
  [
    [
      'Testing Mothers',
      [
        ['Determine HIV Test Kit', :determine_kit, 1.0],
        ['StatPak HIV Test Kit', :statpak_kit, (30.0 / 100.0)],
        ['Unigold HIV Test Kit', :unigold_kit, (2.0 / 100.0)]
      ]
    ]
  ]
],
[
  'Nutrition',
  [
    [
      'Nutrition Supplements for Mothers and Children',
      [
        ['Vitamin A (for under-ones)', :vit_A_1, 1.0],
        ['Vitamin A (for 1-4 years)', :vit_A_2, 2.0],
        ['Deworming Tablets (for children)', :deworming_children, 2.0],
        ['Deworming Tablets (for pregnant mothers)', :deworming_pregnant, 2.0],
        ['Iron Folate', :iron_folate, 90.0],
        ['IPT Fasindar', :ipt_fasindar, 6.0]
      ]
    ]
  ]
],
[
  'EPI',
  [
    [
      'DPT - Hepatitis B + Hib',
      [
        ['Vaccines', :dpt_vaccine, 3.0],
        ['2ml Syringe and Needle', :syringe_needle_2ml, 2],
        ['0.5ml Syringe and Needle', :syringe_needle_05ml, 1]
      ]
    ],
    [
      'Measles',
      [
        ['Vaccines', :measles_vaccine, 1.0],
        ['Diluent', :measles_diluent, 10.0],
        ['5ml Syringe and Needle', :syringe_needle_5ml, 1],
        ['0.5ml Syringe and Needle', :measles_syringe_needle_05ml, 1]
      ]
    ],
    [
      'Polio',
      [
        ['Vaccines', :polio_vaccine, 3.0],
        ['Droppers', :polio_droppers, 20]
      ]
    ],
    [
      'BCG',
      [
        ['Vaccines', :bcg_vaccine, 1.0],
        ['Diluent', :bcg_diluent, 20],
        ['2ml Syringe and Needle', :bcg_syringe_2ml, 1],
        ['0.5ml Syringe and Needle', :bcg_syringe_05ml, 1]
      ]
    ],
    [
      'Tetanus Toxoid',
      [
        ['Vaccines', :tt_vaccine, 2.0],
        ['0.5ml Syringe', :tt_syringe_05ml, 1]
      ]
    ],
    [
      'Others',
      [
        ['Vaccine Carrier + 4 Ice Packs', :vaccine_carrier, 200.0],
        ['Safety Box', :safety_box, 100.0],
        ['Plastic Sheet', :plastic_sheet, 1.0],
        ['Cotton Wool (250mg)', :cotton_wool, 1.0],
        ['Weighing Scales', :weighing_scales, 100]
      ]
    ]
  ]
]
])

# Unhinged assumptions.

asscat   = 'demographics'
hiv_preg = Assumption.create(:name     => 'Expected HIV+ Pregnancies',
                             :category => asscat,
                             :label    => :hiv_preg,
                             :units    => :people,
                             :value    => (6.5 / 100.0))
