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

component = Component.create :name => 'PMTCT'
activity  = Activity.create(:name => 'Testing Mothers')
item1     = ActivityItem.create(:name => 'determine_kit', :description => 'Determine HIV Test Kits')
determine = Assumption.create(:name     => 'Determine HIV Test Kits',
                             :category => component.name,
                             :label    => :determine_kit,
                             :units    => :kits,
                             :value    => 1.0)
item1.assumptions << determine
item2     = ActivityItem.create(:name => 'statpak_kit', :description => 'StatPak HIV Test Kits')
statpak = Assumption.create(:name      => 'StatPak HIV Test Kits',
                             :category => component.name,
                             :label    => :statpak_kit,
                             :units    => :kits,
                             :value    => (30.0 / 100.0))
item2.assumptions << statpak
item3     = ActivityItem.create(:name => 'unigold_kit', :description => 'Unigold HIV Test Kits')
unigold = Assumption.create(:name     => 'unigold HIV Test Kits',
                             :category => component.name,
                             :label    => :unigold_kit,
                             :units    => :kits,
                             :value    => (2.0 / 100.0))
item3.assumptions << unigold

activity.activity_items << item1
activity.activity_items << item2
activity.activity_items << item3

component.activities << activity
component.save

component = Component.create :name => 'Nutrition'
activity  = Activity.create(:name => 'Nutrition Supplements for Mothers and Children')
item1     = ActivityItem.create(:name => 'vit_A_1', :description => 'Vitamin A (for under-ones)')
vit_A_1 = Assumption.create(:name     => 'Vitamin A (for under-ones)',
                             :category => component.name,
                             :label    => :vit_A_1,
                             :units    => :doses,
                             :value    => 1.0)
item1.assumptions << vit_A_1
item2     = ActivityItem.create(:name => 'vit_A_2', :description => 'Vitamin A (for 1-4 years)')
vit_A_2 = Assumption.create(:name      => 'Vitamin A (for 1-4 years)',
                             :category => component.name,
                             :label    => :vit_A_2,
                             :units    => :doses,
                             :value    => 2.0)
item2.assumptions << vit_A_2
item3     = ActivityItem.create(:name => 'deworming_children', :description => 'Deworming Tablets (for children)')
deworming_children = Assumption.create(:name => 'Deworming Tablets (for children)',
                             :category => component.name,
                             :label    => :deworming_children,
                             :units    => :kits,
                             :value    => 2.0)
item3.assumptions << deworming_children
item4     = ActivityItem.create(:name => 'deworming_pregnant', :description => 'Deworming Tablets (for pregnant mothers)')
deworming_pregnant = Assumption.create(:name => 'Deworming Tablets (for pregnant mothers)',
                             :category => component.name,
                             :label    => :deworming_pregnant,
                             :units    => :kits,
                             :value    => 2.0)
item4.assumptions << deworming_pregnant
item5     = ActivityItem.create(:name => 'iron_folate', :description => 'Iron Folate')
iron_folate = Assumption.create(:name => 'Iron  Folate',
                             :category => component.name,
                             :label    => :iron_folate,
                             :units    => :kits,
                             :value    => 90.0)
item5.assumptions << iron_folate
item6     = ActivityItem.create(:name => 'ipt_fasindar', :description => 'IPT Fasindar')
ipt_fasindar = Assumption.create(:name => 'IPT Fasindar',
                             :category => component.name,
                             :label    => :ipt_fasindar,
                             :units    => :kits,
                             :value    => 6.0)
item6.assumptions << ipt_fasindar

activity.activity_items << item1
activity.activity_items << item2
activity.activity_items << item3
activity.activity_items << item4
activity.activity_items << item5
activity.activity_items << item6

component.activities << activity
component.save

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
