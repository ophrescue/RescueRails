class PostalCodeValidator < ActiveModel::Validator
  VALID_US_ZIP_CODE = /\A\d{5}(?:-\d{4})?\z/
  VALID_CANADIAN_POSTAL_CODE = /\A[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]\Z/

  def validate(record)
    return if record.postal_code.blank?

    country = ISO3166::Country.find_country_by_alpha3(record.country)

    unless country
      record.errors[:postal_code] << "cannot be validated without a value for country."
      return
    end

    if country.eql?(ISO3166::Country[:us]) && !record.postal_code.match(VALID_US_ZIP_CODE)
      record.errors[:postal_code] << "should be 12345 or 12345-1234"
    elsif country.eql?(ISO3166::Country[:ca]) && !record.postal_code.match(VALID_CANADIAN_POSTAL_CODE)
      record.errors[:postal_code] << "is not valid"
    end
  end
end
