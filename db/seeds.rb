# encoding: UTF-8
require 'active_support/inflector'

class String
  def nice_capitalize
    self.split(' ').map {|x| x.capitalize}.join(' ')
  end
end

user = User.create(
  [{:username => 'revence', :is_admin => false, :sha1_salt => 'mwahaha', :sha1_pass => 'e643004bb0ad15b6fd350c641f78cb10d46132f5'},
   {:username => 'sharad', :is_admin => true,   :sha1_salt => 'hehehe',  :sha1_pass => '215822e8636cc2aaa8223147d823f02e4344550c'}])

# Geography

ug = Country.create :name => 'Uganda'

File.open(ENV['REGION_DATA'] || %[doc/regiondata.tsv]) do |rd|
  rd.each_line do |ligne|
    reg, dst, tot, u1, a14, prg, sc, par, vens = ligne.strip.split(/\s*\t\s*/).map {|x| (x || '').gsub('"', '')}
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
    district.save
    $stdout.write(((%[\r%s %s: %s] % [region.name, ug.name, district.name]) + (' ' * 80))[0, 75])
    $stdout.flush
    region.districts << district
    region.save
    ug.regions << region
    ug.save
  end
  $stdout.puts
end

File.open(ENV['HEALTH_FACILITIES'] || 'doc/facilities.csv') do |fich|
  fich.each_line do |ligne|
    _, __, dst, ___, cty, hsd, sbc, prs, hun, cod, own, level, stt = ligne.strip.split("\t").map {|x| x.gsub('"', '')}
    district  = District.where(['LOWER(name) = ?', dst.strip.downcase]).first
    if not district then
      raise Exception.new(%[No such district as %s.] % [dst])
    end
    hsub  = HealthSubDistrict.where(['LOWER(name) = ?', hsd.strip.downcase]).first
    if not hsub then
      hsub  = HealthSubDistrict.create :name => hsd.nice_capitalize,
                                :district_id => district.id
    end
    subc  = SubCounty.where(['LOWER(name) = ?', sbc.strip.downcase]).first
    if not subc then
      subc  = SubCounty.create :name  => sbc.nice_capitalize,
              :health_sub_district_id => hsub.id
    end
    parish  = Parish.where(['LOWER(name) = ?', prs.strip.downcase]).first
    if not parish then
      parish  = Parish.create :name => prs.nice_capitalize,
                     :sub_county_id => subc.id
    end
    hunit = HealthUnit.where(['LOWER(name) = ?', hun.strip.downcase]).first
    if not hunit then
      hunit = HealthUnit.create :name => hun.nice_capitalize,
                           :parish_id => parish.id,
                                :code => (cod.empty? ? nil : cod.to_i),
                               :owner => own,
                               :level => level,
                              :status => stt
    end
    $stdout.write(((%[\r%s, %s: %s] % [hsub.name, parish.name, hunit.name]) + (' ' * 80))[0, 75])
    $stdout.flush
    # Then congregation. TODO.
  end
  $stdout.puts
end

# Unhinged assumptions.

asscat  = 'accounting'
rate = Assumption.create(:name     => 'Dollar Rate',
                             :category => asscat,
                             :section  => :accounts,
                             :label    => :dollar_rate,
                             :units    => :local_currency,
                             :value    => 2_500.00)


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

asscat   = 'buffer'
annual_t = Assumption.create(:name     => 'PMTCT Supplies Buffer (30%)',
                             :category => asscat,
                             :section  => :buffer,
                             :label    => :buffer,
                             :units    => :dollars,
                             :value    => 30.0)

asscat   = 'glove endurance'
annual_t = Assumption.create(:name     => 'Latex Gloves Endurance (How many tests per pair?)',
                             :category => asscat,
                             :section  => :gloves_endurance,
                             :label    => :gloves_endurance,
                             :units    => :tests,
                             :value    => 10.0)

asscat   = 'needle holder requirements'
annual_t = Assumption.create(:name     => 'Needle-Holders Required Per Outreach Site',
                             :category => asscat,
                             :section  => :needle_holder_needs,
                             :label    => :needle_holder_needs,
                             :units    => :needle_holders,
                             :value    => 2.0)

asscat   = 'nvp syrup dose'
annual_t = Assumption.create(:name     => 'NVP Syrup Dose',
                             :category => asscat,
                             :section  => :nvp_syrup_dose,
                             :label    => :nvp_syrup_dose,
                             :units    => :ml,
                             :value    => 4.0)

asscat   = 'azt weeks'
annual_t = Assumption.create(:name     => 'Weeks to Administer AZT',
                             :category => asscat,
                             :section  => :azt_weeks,
                             :label    => :azt_weeks,
                             :units    => :weeks,
                             :value    => 26.0)

asscat   = 'azt times a day'
annual_t = Assumption.create(:name     => 'AZT Taken How Many Times A Day?',
                             :category => asscat,
                             :section  => :azt_times,
                             :label    => :azt_times,
                             :units    => :times,
                             :value    => 2.0)

asscat   = 'azt days a week'
annual_t = Assumption.create(:name     => 'AZT Taken How Many Days a Week?',
                             :category => asscat,
                             :section  => :azt_days,
                             :label    => :azt_days,
                             :units    => :days,
                             :value    => 7.0)

asscat   = 'combivir days a week'
annual_t = Assumption.create(:name     => 'Combivir Taken How Many Days a Week?',
                             :category => asscat,
                             :section  => :combivir_days,
                             :label    => :combivir_days,
                             :units    => :days,
                             :value    => 7.0)

asscat   = 'combivir times a day'
annual_t = Assumption.create(:name     => 'Combivir Taken How Many Times A Day?',
                             :category => asscat,
                             :section  => :combivir_times,
                             :label    => :combivir_times,
                             :units    => :times,
                             :value    => 2.0)

asscat   = 'quarters'
annual_t = Assumption.create(:name     => 'Weight of Each Quarter',
                             :category => asscat,
                             :section  => :quarters,
                             :label    => :quarters,
                             :units    => :units,
                             :value    => 0.25)

asscat  = 'management'
[
{:name      => 'Number of Health Workers needed for each contact point',
                             :category => asscat,
                             :section  => :management,
                             :label    => :number_hws,
                             :units    => :HWs,
                             :value    => 2.0},

{:name      => 'Number of days required',
                             :category => asscat,
                             :section  => :management,
                             :label    => :number_days,
                             :units    => :days,
                             :value    => 4.0},

{:name      => 'Fuel multiplicand',
                             :category => asscat,
                             :section  => :management,
                             :label    => :fuel_mult,
                             :units    => :units,
                             :value    => 2.0},

{:name     => 'Cost of district micro-planning',
                             :category => asscat,
                             :section  => :management,
                             :label    => :micro_planning,
                             :units    => :dollars,
                             :value    => 2_000.0},

{:name     => 'Cost of Quarterly Review Meetings',
                             :category => asscat,
                             :section  => :management,
                             :label    => :quarterly_meetings,
                             :units    => :dollars,
                             :value    => 1_000.0},

{:name     => 'Cost of Tents',
                             :category => asscat,
                             :section  => :management,
                             :label    => :tents,
                             :units    => :dollars,
                             :value    => 300.0},

{:name     => 'Health Worker Visibility',
                             :category => asscat,
                             :section  => :management,
                             :label    => :visibility,
                             :units    => :dollars,
                             :value    => 3.0}
].each do |ass|
  a = Assumption.create(ass)
  unless a.valid? then
    raise Exception.new(a.errors.inspect)
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
        if item[2] then
          ah.assumptions << Assumption.create(
            :name => (%[%s (%s)] % [item.first, ah.name]),
            :category => component.name,
            :label => ah.name,
            :value => item[2].to_f,
            :units =>
              (item[1].to_s =~ /^cost/i ?
               :dollars :
               (ah.name.to_s.gsub(/\d.*$/, '').
                  gsub('_', ' ').strip.chomp('s')).pluralize),
            :section => :vacc)
        end
        if item[3] then
          ah.assumptions << Assumption.create(
            :name => (%[Cost per Unit: %s(%s)] % [item.first, ah.name]),
            :category => component.name,
            :label => %[#{ah.name}_cost],
            :value => item[3].to_f,
            :units => :dollars,
            :section => :esti)
        end
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
        ['SDA for Health Workers', :hw_sda],
        ['Fuel', :fuel],
        ['District Micro-Planning', :micro_planning],
        ['Quarterly Review Meetings', :quarterly_meetings],
        ['Tents', :tents],
        ['Health Worker Visibility', :visibility]
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
        ['Unigold HIV Test Kit', :unigold_kit, (2.0 / 100.0), 0.8, []],
        ['Vacutainer', :vacutainer, 1.0, 8.630 / 100.0, []],
        ['Needles (21G x 1")', :needle, 1.0, 6.640 / 100.0, []],
        ['Needle Holders', :needle_holder, 1.0, 16.0 / 250.0, []],
        ['Latex Gloves', :latex_gloves_pair, 1.0, 0.012 / 5.0, []],
        ['Pipettes', :pipette, 1.0, 4.0 / 500.0, []],
        ['NVP Syrup', :nvp_syrup, 365.25, 3.0 / 100.0, []],
        ['NVP Tabs', :nvp_tabs, 1.0, 36.0 / 60.0, []],
        ['AZT Tabs', :azt_tabs, 1.0, 9.0 / 60.0, []],
        ['Combivir', :combivir, 1.0, 11.0 / 60.0, []],
        ['Cotrim 960MG Tabs', :adult_cotrim_tabs, 1.0, 2.0 / 100.0, []],
        ['PædCotrim Tabs', :paed_cotrim_tabs, 1.0, 1.0 / 100.0, []]
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
    # [
    #   'Ante-Natal Care/Post-Natal Care',
    #   [
    #     ['MUAC (Child)'],
    #     ['MUAC (Adult)'],
    #     ['BP Machine'],
    #     ['Fœtoscope'],
    #     ['Measuring Tape'],
    #     ['Uristix'],
    #     ['Newborn Thermometre'],
    #     ['Newborn Weighing Scale'],
    #     ['Respiratory Timer'],
    #     ['Tetracycline Eye Ointment'],
    #     ['Disinfectant Solution / Jik'],
    #     ['Latex Gloves'],
    #     ['Job Aides (MNH/iCCM)'],
    #     ['Mother Child Health Passport'],
    #     ['Child Health Cards']
    #   ]
    # ],
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
