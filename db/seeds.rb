user = User.create(
  [{:username => 'revence', :is_admin => false, :sha1_salt => 'mwahaha', :sha1_pass => 'e643004bb0ad15b6fd350c641f78cb10d46132f5'},
   {:username => 'sharad', :is_admin => true,   :sha1_salt => 'hehehe',  :sha1_pass => '215822e8636cc2aaa8223147d823f02e4344550c'}])

# Geography

ug = Country.create :name => 'Uganda'

File.open(ENV['REGION_DATA'] || %[doc/regiondata.tsv]) do |rd|
  rd.each_line do |ligne|
    reg, dst, tot, u1, a14, prg, sc, par, vens = ligne.strip.split(/\s*\t\s*/)
    region    = Region.find_by_name reg
    unless region then
      region    = Region.create :name => reg
      region.save
    end
    district  = District.create :name => dst
    begin
      district.district_data = DistrictData.create(
               :population => tot.gsub(/\D/, '').to_i,
                :under_one => u1.gsub(/\D/, '').to_i,
              :one_to_four => a14.gsub(/\D/, '').to_i,
              :pregnancies => prg.gsub(/\D/, '').to_i,
      :number_sub_counties => sc.gsub(/\D/, '').to_i,
          :number_parishes => par.gsub(/\D/, '').to_i,
            :number_venues => (vens || '0').gsub(/\D/, '').to_i)
    rescue Exception => e
      raise Exception.new(e.message + %[ on #{ligne.inspect}])
    end
    region.districts << district
    ug.regions << region
  end
end

# Unhinged assumptions.

asscat   = 'demographics'
hiv_preg = Assumption.create(:name     => 'Expected HIV+ Pregnancies',
                             :category => asscat,
                             :section  => :demog,
                             :label    => :hiv_preg,
                             :units    => :people,
                             :value    => (6.5 / 100.0))

asscat   = 'annual_total'
annual_t = Assumption.create(:name     => 'Total Cost of Supplies (annual)',
                             :category => asscat,
                             :section  => :annual_total,
                             :label    => :annual_total,
                             :units    => :dollars,
                             :value    => 1.0)

asscat   = 'wastage'
annual_t = Assumption.create(:name     => 'Cost of Wasted Supplies (10%)',
                             :category => asscat,
                             :section  => :wastage,
                             :label    => :wastage,
                             :units    => :dollars,
                             :value    => 10.0)

asscat   = 'quarters'
annual_t = Assumption.create(:name     => 'Weight of Each Quarter',
                             :category => asscat,
                             :section  => :quarters,
                             :label    => :quarters,
                             :units    => :units,
                             :value    => 0.25)

# Components

proc do |them|
  them.each do |it|
    component = Component.create :name => it.first
    it.last.each do |act|
      activity  = Activity.create  :name => act.first
      act.last.each do |item|
        ah = ActivityItem.create(:name => item[1] || item.first.downcase.gsub(/[^a-z]/, ''), :description => item.first)
        ah.assumptions << Assumption.create(:category => component.name, :label => ah.name, :value => item[2].to_f, :section => :vacc)
        ah.assumptions << Assumption.create(:category => component.name, :label => %[#{ah.name}_cost], :value => item[3].to_f, :section => :esti)
        ah.assumptions.each do |ass|
          raise Exception.new(ass.errors.messages) unless ass.valid?
        end
        activity.activity_items << ah
      end
      component.activities << activity
    end
    component.save
  end
end.call([
[
  'Birth and Death Registration',
  [
    [
      'Registrations',
      [
        ['Cost for Printing Certificates', :certificates, 2.0, 1.0, []],
        ['Printers and Laptops', :printers_laptops, 2.0, 700.0, []],
        ['SDA Parish Priest & Sub-County Chief', :priests, 4.0, 1.0, []]
      ]
    ]
  ]
],
[
  'Other Associated Costs',
  [
    [
      'Management of &ldquo;The Accelerated Approach&rdquo;',
      [
        ['SDA for Health Workers', :hws, 2.0, 2.5, []],
        ['Fuel', :fuel, 1.0, 2.0, []],
        ['District Micro-Planning', :micro_planning, 4.0, 2000.0, []],
        ['Quarterly Review Meetings', :quarterly_meetings, 4.0, 1000.0, []],
        ['Tents', :tents, 1.0, 300.0, []],
        ['Health Worker Visibility', :visibility, 1.0, 3.0, []]
      ]
    ]
  ]
],
[
  'PMTCT',
  [
    [
      'Testing Mothers',
      [
        ['Determine HIV Test Kit', :determine_kit, 1.0, 0.8, []],
        ['StatPak HIV Test Kit', :statpak_kit, (30.0 / 100.0), 0.8, []],
        ['Unigold HIV Test Kit', :unigold_kit, (2.0 / 100.0), 0.8, []]
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
        ['Vitamin A (for under-ones)', :vit_A_1, 1.0, 0.12, []],
        ['Vitamin A (for 1-4 years)', :vit_A_2, 2.0, 0.12, []],
        ['Deworming Tablets (for children)', :deworming_children, 2.0, 0.02, []],
        ['Deworming Tablets (for pregnant mothers)', :deworming_pregnant, 2.0, 0.02, []],
        ['Iron Folate', :iron_folate, 90.0, 0.003, []],
        ['IPT Fasindar', :ipt_fasindar, 6.0, 0.027, []]
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
        ['Vaccines', :dpt_vaccine, 3.0, 3.6, []],
        ['2ml Syringe and Needle', :syringe_needle_2ml, 2, 0.023, []],
        ['0.5ml Syringe and Needle', :syringe_needle_05ml, 1, 0.057, []]
      ]
    ],
    [
      'Measles',
      [
        ['Vaccines', :measles_vaccine, 1.0, 0.257, []],
        ['Diluent', :measles_diluent, 10.0, 0.0, []],
        ['5ml Syringe and Needle', :syringe_needle_5ml, 1, 0.03, []],
        ['0.5ml Syringe and Needle', :measles_syringe_needle_05ml, 1, 0.057, []]
      ]
    ],
    [
      'Polio',
      [
        ['Vaccines', :polio_vaccine, 3.0, 0.1285, []],
        ['Droppers', :polio_droppers, 20, 0.0, []]
      ]
    ],
    [
      'BCG',
      [
        ['Vaccines', :bcg_vaccine, 1.0, 0.8, []],
        ['Diluent', :bcg_diluent, 20, 0.0, []],
        ['2ml Syringe and Needle', :bcg_syringe_2ml, 1, 0.023, []],
        ['0.5ml Syringe and Needle', :bcg_syringe_05ml, 1, 0.0068]
      ]
    ],
    [
      'Tetanus Toxoid',
      [
        ['Vaccines', :tt_vaccine, 2.0, 0.034, []],
        ['0.5ml Syringe', :tt_syringe_05ml, 1, 0.057, []]
      ]
    ],
    [
      'Others',
      [
        ['Vaccine Carrier + 4 Ice Packs', :vaccine_carrier, 200.0, 0.035, []],
        ['Safety Box', :safety_box, 100.0, 0.658, []],
        ['Plastic Sheet', :plastic_sheet, 1.0, 1.0, []],
        ['Cotton Wool (250mg)', :cotton_wool, 1.0, 0.08, []],
        ['Weighing Scales', :weighing_scales, 100, 1, []]
      ]
    ]
  ]
]
])
