class Functions
  def self.hiv_preg val, rec
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit val, rec
    rec.district_data.pregnancies
  end

  def self.statpak_kit val, rec
    val.value * determine_kit(Assumption.find_by_label(:hiv_preg), rec)
  end

  def self.unigold_kit val, rec
    val.value * determine_kit(Assumption.find_by_label(:hiv_preg), rec)
  end
end
