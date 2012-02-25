class Functions
  def self.hiv_preg val, rec
    val ||= Assumption.find_by_label(:hiv_preg)
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit val, rec
    val ||= Assumption.find_by_label(:determine_kit)
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit_cost val, rec
    val ||= Assumption.find_by_label(:determine_kit_cost)
    determine_kit(nil, rec) * val.value
  end

  def self.statpak_kit val, rec
    val ||= Assumption.find_by_label(:statpak_kit)
    val.value * determine_kit(nil, rec)
  end

  def self.statpak_kit_cost val, rec
    val ||= Assumption.find_by_label(:statpak_kit_cost)
    val.value * statpak_kit(nil, rec)
  end

  def self.unigold_kit val, rec
    val ||= Assumption.find_by_label(:unigold_kit)
    val.value * determine_kit(nil, rec)
  end

  def self.unigold_kit_cost val, rec
    val ||= Assumption.find_by_label(:unigold_kit_cost)
    val.value * unigold_kit(nil, rec)
  end

  def self.vit_A_1 val, rec
    val ||= Assumption.find_by_label(:vit_A_1)
    val.value * rec.district_data.under_one
  end

  def self.vit_A_1_cost val, rec
    val ||= Assumption.find_by_label(:vit_A_1_cost)
    val.value * vit_A_1(nil, rec)
  end

  def self.vit_A_2 val, rec
    val ||= Assumption.find_by_label(:vit_A_2)
    rec.district_data.one_to_four * val.value
  end

  def self.vit_A_2_cost val, rec
    val ||= Assumption.find_by_label(:vit_A_2_cost)
    vit_A_2(nil, rec) * val.value
  end

  def self.deworming_children val, rec
    val ||= Assumption.find_by_label(:deworming_children)
    rec.district_data.one_to_four * val.value
  end

  def self.deworming_children_cost val, rec
    val ||= Assumption.find_by_label(:deworming_children_cost)
    deworming_children(nil, rec) * val.value
  end

  def self.deworming_pregnant val, rec
    val ||= Assumption.find_by_label(:deworming_pregnant)
    rec.district_data.pregnancies * val.value
  end

  def self.deworming_pregnant_cost val, rec
    val ||= Assumption.find_by_label(:deworming_pregnant_cost)
    deworming_pregnant(nil, rec) * val.value
  end

  def self.iron_folate val, rec
    val ||= Assumption.find_by_label(:iron_folate)
    rec.district_data.pregnancies * val.value
  end

  def self.iron_folate_cost val, rec
    val ||= Assumption.find_by_label(:iron_folate_cost)
    iron_folate(nil, rec) * val.value
  end

  def self.ipt_fasindar val, rec
    val ||= Assumption.find_by_label(:ipt_fasindar)
    rec.district_data.pregnancies * val.value
  end

  def self.ipt_fasindar_cost val, rec
    val ||= Assumption.find_by_label(:ipt_fasindar_cost)
    ipt_fasindar(nil, rec) * val.value
  end

  def self.dpt_vaccine val, rec
    val ||= Assumption.find_by_label(:dpt_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.dpt_vaccine_cost val, rec
    val ||= Assumption.find_by_label(:dpt_vaccine_cost)
    dpt_vaccine(nil, rec) * val.value
  end

  def self.syringe_needle_2ml val, rec
    val ||= Assumption.find_by_label(:syringe_needle_2ml)
    dpt_vaccine(nil, rec) / val.value
  end

  def self.syringe_needle_2ml_cost val, rec
    val ||= Assumption.find_by_label(:syringe_needle_2ml_cost)
    syringe_needle_2ml(nil, rec) * val.value
  end

  def self.syringe_needle_05ml val, rec
    val ||= Assumption.find_by_label(:syringe_needle_05ml)
    dpt_vaccine nil, rec
  end

  def self.syringe_needle_05ml_cost val, rec
    val ||= Assumption.find_by_label(:syringe_needle_05ml_cost)
    val.value * syringe_needle_05ml(nil, rec)
  end

  def self.measles_vaccine val, rec
    val ||= Assumption.find_by_label(:measles_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.measles_vaccine_cost val, rec
    val ||= Assumption.find_by_label(:measles_vaccine_cost)
    measles_vaccine(nil, rec) * val.value
  end

  def self.measles_diluent val, rec
    val ||= Assumption.find_by_label(:measles_diluent)
    measles_vaccine(nil, rec) / val.value
  end

  def self.measles_diluent_cost val, rec
    val ||= Assumption.find_by_label(:measles_diluent_cost)
    measles_diluent(nil, rec) * val.value
  end

  def self.syringe_needle_5ml val, rec
    val ||= Assumption.find_by_label(:syringe_needle_5ml)
    measles_diluent(nil, rec) * val.value
  end

  def self.syringe_needle_5ml_cost val, rec
    val ||= Assumption.find_by_label(:syringe_needle_5ml_cost)
    syringe_needle_5ml(nil, rec) * val.value
  end

  def self.measles_syringe_needle_05ml val, rec
    val ||= Assumption.find_by_label :measles_syringe_needle_05ml
    measles_vaccine(nil, rec) * val.value
  end

  def self.measles_syringe_needle_05ml_cost val, rec
    val ||= Assumption.find_by_label :measles_syringe_needle_05ml_cost
    measles_syringe_needle_05ml(nil, rec) * val.value
  end

  def self.polio_vaccine val, rec
    val ||= Assumption.find_by_label(:polio_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.polio_vaccine_cost val, rec
    val ||= Assumption.find_by_label(:polio_vaccine_cost)
    polio_vaccine(nil, rec) * val.value
  end

  def self.polio_droppers val, rec
    val ||= Assumption.find_by_label(:polio_droppers)
    polio_vaccine(nil, rec) / val.value
  end

  def self.polio_droppers_cost val, rec
    val ||= Assumption.find_by_label(:polio_droppers_cost)
    polio_droppers(nil, rec) * val.value
  end

  def self.bcg_vaccine val, rec
    val ||= Assumption.find_by_label(:bcg_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.bcg_vaccine_cost val, rec
    val ||= Assumption.find_by_label(:bcg_vaccine_cost)
    bcg_vaccine(nil, rec) * val.value
  end

  def self.bcg_diluent val, rec
    val ||= Assumption.find_by_label(:bcg_diluent)
    bcg_vaccine(nil, rec) / val.value
  end

  def self.bcg_diluent_cost val, rec
    val ||= Assumption.find_by_label(:bcg_diluent_cost)
    bcg_diluent(nil, rec) * val.value
  end

  def self.bcg_syringe_2ml val, rec
    val ||= Assumption.find_by_label(:bcg_syringe_2ml)
    bcg_diluent nil, rec
  end

  def self.bcg_syringe_2ml_cost val, rec
    val ||= Assumption.find_by_label(:bcg_syringe_2ml_cost)
    val.value * bcg_syringe_2ml(nil, rec)
  end

  def self.bcg_syringe_05ml val, rec
    val ||= Assumption.find_by_label(:bcg_syringe_05ml)
    bcg_syringe_2ml nil, rec
  end

  def self.bcg_syringe_05ml_cost val, rec
    val ||= Assumption.find_by_label(:bcg_syringe_05ml_cost)
    val.value * bcg_syringe_05ml(nil, rec)
  end

  def self.tt_vaccine val, rec
    val ||= Assumption.find_by_label :tt_vaccine
    rec.district_data.pregnancies * val.value
  end

  def self.tt_vaccine_cost val, rec
    val ||= Assumption.find_by_label :tt_vaccine_cost
    tt_vaccine(nil, rec) * val.value
  end

  def self.tt_syringe_05ml val, rec
    val ||= Assumption.find_by_label :tt_syringe_05ml
    tt_vaccine(nil, rec) * val.value
  end
  def self.tt_syringe_05ml_cost val, rec
    val ||= Assumption.find_by_label :tt_syringe_05ml_cost
    tt_syringe_05ml(nil, rec) * val.value
  end

  def self.vaccine_carrier val, rec
    val ||= Assumption.find_by_label :vaccine_carrier
    rec.district_data.under_one / val.value
  end

  def self.vaccine_carrier_cost val, rec
    val ||= Assumption.find_by_label :vaccine_carrier_cost
    vaccine_carrier(nil, rec) * val.value
  end

  def self.safety_box val, rec
    val ||= Assumption.find_by_label :safety_box
    [
      tt_syringe_05ml(nil, rec),
      bcg_syringe_05ml(nil, rec),
      bcg_syringe_2ml(nil, rec),
      measles_syringe_needle_05ml(nil, rec),
      syringe_needle_5ml(nil, rec),
      syringe_needle_05ml(nil, rec),
      syringe_needle_2ml(nil, rec)
    ].sum / val.value
  end

  def self.safety_box_cost val, rec
    val ||= Assumption.find_by_label :safety_box_cost
    safety_box(nil, rec) * val.value
  end

  def self.plastic_sheet val, rec
    val ||= Assumption.find_by_label :plastic_sheet
    vaccine_carrier(nil, rec)
  end

  def self.plastic_sheet_cost val, rec
    val ||= Assumption.find_by_label :plastic_sheet_cost
    plastic_sheet(nil, rec) * val.value
  end

  def self.cotton_wool val, rec
    val ||= Assumption.find_by_label :cotton_wool
    rec.district_data.under_one / val.value
  end

  def self.cotton_wool_cost val, rec
    val ||= Assumption.find_by_label :cotton_wool_cost
    cotton_wool(nil, rec) * val.value
  end

  def self.weighing_scales val, rec
    val ||= Assumption.find_by_label :weighing_scales
    rec.district_data.pregnancies / val.value
  end

  def self.weighing_scales_cost val, rec
    val ||= Assumption.find_by_label :weighing_scales_cost
    weighing_scales(nil, rec) * val.value
  end

  def self.annual_total val, rec, items
    val ||= Assumption.find_by_label :annual_total
    dem = Set.new
    items.each do |item|
      item.assumptions.each do |ass|
        dem << ass.label
      end
    end
    self.methods.select {|m| (m.to_s =~ /_cost$/) and dem.member?(m.to_s)}.inject(0) do |p, n|
      p + self.send(n, nil, rec)
    end
  end

  def self.wastage val, rec, mass_total
    val ||= Assumption.find_by_label :wastage
    mass_total / val.value
  end

  def self.quarters val, rec
    val ||= Assumption.find_by_label :quarters
    val.value
  end

  def self.certificates val, rec
    val ||= Assumption.find_by_label :certificates
    rec.district_data.under_one / val.value
  end

  def self.certificates_cost val, rec
    val ||= Assumption.find_by_label :certificates_cost
    val.value * certificates(nil, rec)
  end

  def self.printers_laptops val, rec
    val ||= Assumption.find_by_label :printers_laptops
    rec.district_data.number_sub_counties / val.value
  end

  def self.printers_laptops_cost val, rec
    val ||= Assumption.find_by_label :printers_laptops_cost
    val.value * printers_laptops(nil, rec)
  end

  def self.priests val, rec
    val ||= Assumption.find_by_label :priests
    val.value * rec.district_data.under_one
  end

  def self.priests_cost val, rec
    val ||= Assumption.find_by_label :priests_cost
    val.value * priests(nil, rec)
  end

  def self.number_hws val, rec
    val = Assumption.find_by_label :number_hws
    [rec.district_data.number_venues, rec.district_data.number_parishes].max * val.value
  end

  def self.number_days val, rec; end

  def self.hw_sda val, rec
    val = Assumption.find_by_label :number_hws
    dys = Assumption.find_by_label :number_days
    number_hws(val, rec) * dys.value
  end

  def self.fuel_mult val, rec; end

  def self.fuel val, rec
    ful = Assumption.find_by_label :fuel_mult
    val = number_hws(val, rec)
    dys = Assumption.find_by_label :number_days
    ful.value * val * dys.value
  end

  def self.micro_planning val, rec
    val = Assumption.find_by_label :micro_planning
    qtr = Assumption.find_by_label :quarters
    val.value * (1.0 / qtr.value)
  end

  def self.quarterly_meetings val, rec
    val = Assumption.find_by_label :quarterly_meetings
    qtr = Assumption.find_by_label :quarters
    val.value * (1.0 / qtr.value)
  end

  def self.tents val, rec
    val = Assumption.find_by_label :tents
    val.value * [rec.district_data.number_venues, rec.district_data.number_parishes].max
  end

  def self.visibility val, rec
    val = Assumption.find_by_label :visibility
    number_hws(val, rec) * val.value
  end

  def self.buffer val, rec
    val ||= Assumption.find_by_label(:buffer)
    val.value
  end

  def self.vacutainer val, rec
    val = Assumption.find_by_label :vacutainer
    val.value * rec.district_data.pregnancies
  end

  def self.vacutainer_cost val, rec
    val = Assumption.find_by_label :vacutainer_cost
    val.value * rec.district_data.pregnancies
  end

  def self.needle val, rec
    val ||= Assumption.find_by_label :needle
    val.value * rec.district_data.pregnancies
  end

  def self.needle_cost val, rec
    val ||= Assumption.find_by_label :needle_cost
    val.value * rec.district_data.pregnancies
  end

  def self.needle_holder val, rec
    val ||= Assumption.find_by_label :needle_holder
    val.value * [rec.district_data.number_venues, rec.district_data.number_parishes].max * needle_holder_needs(nil, rec)
  end

  def self.needle_holder_cost val, rec
    val ||= Assumption.find_by_label :needle_holder_cost
    val.value * [rec.district_data.number_venues, rec.district_data.number_parishes].max * needle_holder_needs(nil, rec)
  end

  def self.needle_holder_needs val, rec
    val ||= Assumption.find_by_label :needle_holder_needs
    val.value
  end

  def self.gloves_endurance val, rec
    val ||= Assumption.find_by_label(:gloves_endurance)
    val.value
  end

  def self.latex_gloves_pair val, rec
    val ||= Assumption.find_by_label :latex_gloves_pair
    gle   = Assumption.find_by_label :gloves_endurance
    val.value * (rec.district_data.pregnancies / gle.value).ceil
  end

  def self.latex_gloves_pair_cost val, rec
    val ||= Assumption.find_by_label :latex_gloves_pair_cost
    gle   = Assumption.find_by_label :gloves_endurance
    val.value * (rec.district_data.pregnancies / gle.value).ceil
  end

  def self.pipette val, rec
    val = Assumption.find_by_label :pipette
    val.value * determine_kit(nil, rec)
  end

  def self.pipette_cost val, rec
    val = Assumption.find_by_label :pipette_cost
    val.value * determine_kit(nil, rec)
  end

  def self.nvp_syrup_dose val, rec
    val = Assumption.find_by_label :nvp_syrup_dose
    val.value
  end

  def self.azt_times val, rec
    Assumption.find_by_label(:azt_times).value
  end

  def self.azt_weeks val, rec
    Assumption.find_by_label(:azt_weeks).value
  end

  def self.azt_days val, rec
    Assumption.find_by_label(:azt_days).value
  end

  def self.combivir_days val, rec
    Assumption.find_by_label(:combivir_days).value
  end

  def self.combivir_times val, rec
    Assumption.find_by_label(:combivir_times).value
  end

  def self.nvp_syrup val, rec
    val = Assumption.find_by_label :nvp_syrup
    nvd = Assumption.find_by_label :nvp_syrup_dose
    nvd.value * val.value * hiv_preg(nil, rec)
  end

  def self.nvp_syrup_cost val, rec
    val = Assumption.find_by_label :nvp_syrup_cost
    nvd = Assumption.find_by_label :nvp_syrup_dose
    nvd.value * val.value * hiv_preg(nil, rec)
  end

  def self.nvp_tabs val, rec
    val = Assumption.find_by_label :nvp_tabs
    val.value * hiv_preg(nil, rec)
  end

  def self.nvp_tabs_cost val, rec
    val = Assumption.find_by_label :nvp_tabs_cost
    val.value * hiv_preg(nil, rec)
  end

  def self.adult_cotrim_tabs val, rec
    val = Assumption.find_by_label :adult_cotrim_tabs
    val.value * hiv_preg(nil, rec)
  end

  def self.adult_cotrim_tabs_cost val, rec
    val = Assumption.find_by_label :adult_cotrim_tabs_cost
    val.value * hiv_preg(nil, rec)
  end

  def self.paed_cotrim_tabs val, rec
    val = Assumption.find_by_label :paed_cotrim_tabs
    val.value * hiv_preg(nil, rec)
  end

  def self.paed_cotrim_tabs_cost val, rec
    val = Assumption.find_by_label :paed_cotrim_tabs_cost
    val.value * hiv_preg(nil, rec)
  end

  def self.azt_tabs val, rec
    val ||= Assumption.find_by_label :azt_tabs
    wks   = Assumption.find_by_label :azt_weeks
    dys   = Assumption.find_by_label :azt_days
    tms   = Assumption.find_by_label :azt_times
    val.value * wks.value * dys.value * tms.value * hiv_preg(nil, rec)
  end

  def self.azt_tabs_cost val, rec
    val ||= Assumption.find_by_label :azt_tabs_cost
    wks   = Assumption.find_by_label :azt_weeks
    dys   = Assumption.find_by_label :azt_days
    tms   = Assumption.find_by_label :azt_times
    val.value * wks.value * dys.value * tms.value * hiv_preg(nil, rec)
  end

  def self.combivir val, rec
    val = Assumption.find_by_label :combivir
    dys = Assumption.find_by_label :combivir_days
    tms = Assumption.find_by_label :combivir_times
    val.value * dys.value * tms.value * hiv_preg(nil, rec)
  end

  def self.combivir_cost val, rec
    val = Assumption.find_by_label :combivir_cost
    dys = Assumption.find_by_label :combivir_days
    tms = Assumption.find_by_label :combivir_times
    val.value * dys.value * tms.value * hiv_preg(nil, rec)
  end
end
