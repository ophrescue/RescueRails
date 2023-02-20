class RegionValidator < ActiveModel::Validator
  PROVINCES = %w[AB BC MB NB NL NS ON PE QC SK NT NU YT].freeze

  def validate(record)
    country = ISO3166::Country.find_country_by_alpha3(record.country)

    if country.nil?
      record.errors.add(:region, message: "cannot be validated without a value for country.")
      return
    end

    if country.eql? ISO3166::Country[:us]
      validate_state(record)
    elsif country.eql? ISO3166::Country[:ca]
      validate_province(record)
    end
  end

  private

  def validate_state(record)
    if record.region.blank?
      record.errors.add(:region, message: "State cannot be blank.")
      return
    end
    record.errors.add(:region, message: "State is the wrong length (should be 2 letters).") unless record.region.length == 2
  end

  def validate_province(record)
    if record.region.blank?
      record.errors.add(:region, message: "Province cannot be blank.")
      return
    end

    unless record.region.length == 2
      record.errors.add(:region, message: "Province is the wrong length (should be 2 letters).")
      return
    end
    record.errors.add(:region, message: "'#{record.region}' is not a valid province.") unless PROVINCES.include? record.region
  end
end
