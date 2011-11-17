class Functions
  def self.hiv_preg val, rec
    val ||= Assumption.find_by_label(:hiv_preg)
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit val, rec
    rec.district_data.pregnancies
  end

  def self.statpak_kit val, rec
    val.value * determine_kit(nil, rec)
  end

  def self.unigold_kit val, rec
    val.value * determine_kit(nil, rec)
  end

  def self.vit_A_1 val, rec
    val.value * rec.district_data.under_one
  end

  def self.vit_A_2 val, rec
    rec.district_data.one_to_four * val.value
  end

  def self.deworming_children val, rec
    rec.district_data.one_to_four * val.value
  end

  def self.deworming_pregnant val, rec
    rec.district_data.pregnancies * val.value
  end

  def self.iron_folate val, rec
    rec.district_data.pregnancies * val.value
  end

  def self.ipt_fasindar val, rec
    rec.district_data.pregnancies * val.value
  end

  def self.dpt_vaccine val, rec
    val ||= Assumption.find_by_label(:dpt_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.syringe_needle_2ml val, rec
    dpt_vaccine(nil, rec) / val.value
  end

  def self.syringe_needle_05ml val, rec
    dpt_vaccine nil, rec
  end

  def self.measles_vaccine val, rec
    val ||= Assumption.find_by_label(:measles_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.measles_diluent val, rec
    val ||= Assumption.find_by_label(:measles_diluent)
    measles_vaccine(nil, rec) / val.value
  end

  def self.syringe_needle_5ml val, rec
    measles_diluent(nil, rec) * val.value
  end

  def self.measles_syringe_needle_05ml val, rec
    measles_vaccine(nil, rec) * val.value
  end

  def self.polio_vaccine val, rec
    val ||= Assumption.find_by_label(:polio_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.polio_droppers val, rec
    polio_vaccine(nil, rec) / val.value
  end

  def self.bcg_vaccine val, rec
    val ||= Assumption.find_by_label(:bcg_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.bcg_diluent val, rec
    val ||= Assumption.find_by_label(:bcg_diluent)
    bcg_vaccine(nil, rec) / val.value
  end

  def self.bcg_syringe_2ml val, rec
    val ||= Assumption.find_by_label(:bcg_diluent)
    bcg_diluent nil, rec
  end

  def self.bcg_syringe_05ml val, rec
    bcg_syringe_2ml nil, rec
  end

  def self.tt_vaccine val, rec
    val ||= Assumption.find_by_label :tt_vaccine
    rec.district_data.pregnancies * val.value
  end

  def self.tt_syringe_05ml val, rec
    tt_vaccine(nil, rec) * val.value
  end

  def self.vaccine_carrier val, rec
    val ||= Assumption.find_by_label :vaccine_carrier
    rec.district_data.under_one / val.value
  end

  def self.safety_box val, rec
    val ||= Assumption.find_by_label :vaccine_carrier
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

  def self.plastic_sheet val, rec
    vaccine_carrier(nil, rec)
  end

  def self.cotton_wool val, rec
    vaccine_carrier(nil, rec)
    val ||= Assumption.find_by_label :vaccine_carrier
    rec.district_data.under_one / val.value
  end

  def self.weighing_scales val, rec
    rec.district_data.pregnancies / val.value
  end
end
