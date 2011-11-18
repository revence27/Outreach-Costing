class Functions
  def self.hiv_preg val, rec
    val ||= Assumption.find_by_label(:hiv_preg)
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit val, rec
    val ||= Assumption.find_by_label(:determine_kit)
    rec.district_data.pregnancies
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

  def self.wastage val, rec, sum_total
    val ||= Assumption.find_by_label :wastage
    sum_total / val.value
  end
end
