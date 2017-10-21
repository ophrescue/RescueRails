class PostalCodeValidator < ActiveModel::Validator
  ZIP_CODE_REGEX = /\A\d{5}(?:-\d{4})?\z/
  POSTAL_CODE_REGEX = /\A[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]\Z/

  def validate(record)
    return if record.postal_code.blank?

    country = ISO3166::Country.find_country_by_alpha3(record.country)

    unless country
      record.errors[:postal_code] << "cannot be validated without a value for country."
      return
    end

    postal_code = record.postal_code.delete(' ').upcase

    if country.eql?(ISO3166::Country[:us]) && !postal_code.match(ZIP_CODE_REGEX)
      record.errors[:postal_code] << "should be 12345 or 12345-1234"
    elsif country.eql?(ISO3166::Country[:ca]) && !postal_code.match(POSTAL_CODE_REGEX)
      record.errors[:postal_code] << "is not valid"
    end
  end
end
