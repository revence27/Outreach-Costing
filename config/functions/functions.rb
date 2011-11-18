class Functions
  def self.hiv_preg val, rec, part
    val ||= Assumption.find_by_label(:hiv_preg)
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit val, rec, part
    rec.district_data.pregnancies
  end

  def self.statpak_kit val, rec, part
    val.value * determine_kit(nil, rec, part)
  end

  def self.unigold_kit val, rec, part
    val.value * determine_kit(nil, rec, part)
  end

  def self.vit_A_1 val, rec, part
    val.value * rec.district_data.under_one
  end

  def self.vit_A_2 val, rec, part
    rec.district_data.one_to_four * val.value
  end

  def self.deworming_children val, rec, part
    rec.district_data.one_to_four * val.value
  end

  def self.deworming_pregnant val, rec, part
    rec.district_data.pregnancies * val.value
  end

  def self.iron_folate val, rec, part
    rec.district_data.pregnancies * val.value
  end

  def self.ipt_fasindar val, rec, part
    rec.district_data.pregnancies * val.value
  end

  def self.dpt_vaccine val, rec, part
    val ||= Assumption.find_by_label(:dpt_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.syringe_needle_2ml val, rec, part
    val ||= Assumption.find_by_label(:syringe_needle_2ml)
    dpt_vaccine(nil, rec, part) / val.value
  end

  def self.syringe_needle_05ml val, rec, part
    val ||= Assumption.find_by_label(:syringe_needle_05ml)
    dpt_vaccine nil, rec, part
  end

  def self.measles_vaccine val, rec, part
    val ||= Assumption.find_by_label(:measles_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.measles_diluent val, rec, part
    val ||= Assumption.find_by_label(:measles_diluent)
    measles_vaccine(nil, rec, part) / val.value
  end

  def self.syringe_needle_5ml val, rec, part
    val ||= Assumption.find_by_label(:syringe_needle_5ml)
    measles_diluent(nil, rec, part) * val.value
  end

  def self.measles_syringe_needle_05ml val, rec, part
    val ||= Assumption.find_by_label :measles_syringe_needle_05ml
    measles_vaccine(nil, rec, part) * val.value
  end

  def self.polio_vaccine val, rec, part
    val ||= Assumption.find_by_label(:polio_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.polio_droppers val, rec, part
    polio_vaccine(nil, rec, part) / val.value
  end

  def self.bcg_vaccine val, rec, part
    val ||= Assumption.find_by_label(:bcg_vaccine)
    rec.district_data.under_one * val.value
  end

  def self.bcg_diluent val, rec, part
    val ||= Assumption.find_by_label(:bcg_diluent)
    bcg_vaccine(nil, rec, part) / val.value
  end

  def self.bcg_syringe_2ml val, rec, part
    val ||= Assumption.find_by_label(:bcg_diluent)
    bcg_diluent nil, rec, part
  end

  def self.bcg_syringe_05ml val, rec, part
    bcg_syringe_2ml nil, rec, part
  end

  def self.tt_vaccine val, rec, part
    val ||= Assumption.find_by_label :tt_vaccine
    rec.district_data.pregnancies * val.value
  end

  def self.tt_syringe_05ml val, rec, part
    val ||= Assumption.find_by_label :tt_syringe_05ml
    tt_vaccine(nil, rec, part) * val.value
  end

  def self.vaccine_carrier val, rec, part
    val ||= Assumption.find_by_label :vaccine_carrier
    rec.district_data.under_one / val.value
  end

  def self.safety_box val, rec, part
    val ||= Assumption.find_by_label :vaccine_carrier
    [
      tt_syringe_05ml(nil, rec, part),
      bcg_syringe_05ml(nil, rec, part),
      bcg_syringe_2ml(nil, rec, part),
      measles_syringe_needle_05ml(nil, rec, part),
      syringe_needle_5ml(nil, rec, part),
      syringe_needle_05ml(nil, rec, part),
      syringe_needle_2ml(nil, rec, part)
    ].sum / val.value
  end

  def self.plastic_sheet val, rec, part
    vaccine_carrier(nil, rec, part)
  end

  def self.cotton_wool val, rec, part
    vaccine_carrier(nil, rec)
    val ||= Assumption.find_by_label :vaccine_carrier
    rec.district_data.under_one / val.value
  end

  def self.weighing_scales val, rec, part
    rec.district_data.pregnancies / val.value
  end
end
