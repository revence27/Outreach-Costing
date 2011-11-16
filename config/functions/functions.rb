class Functions
  def self.hiv_preg val, rec
    val.value * rec.district_data.pregnancies
  end

  def self.determine_kit val, rec
    hiv_preg val, rec
  end

  def self.statpak_kit val, rec
    val.value * determine_kit(val, rec)
  end

  def self.unigold_kit val, rec
    val.value * determine_kit(val, rec)
  end
end
