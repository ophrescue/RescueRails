module DogsHelper
  def profile_line_2
    return if no_caveats?
    "#{pronoun} #{caveats.join(', ')}"
  end

  def caveats
    caveats = []
    caveats << "is a special needs dog" if @dog.is_special_needs
    caveats << "is not good with other dogs" if @dog.no_dogs
    caveats << "is not good with cats" if @dog.no_cats
    caveats << "is not good for homes with small children" if @dog.no_kids
    caveats[-1] += "."
    caveats[-1] = "and "+caveats[-1] if caveats.length > 1
    caveats
  end

  def no_caveats?
    ![@dog.is_special_needs, @dog.no_dogs, @dog.no_cats, @dog.no_kids].any?
  end

  def spay_or_neuter_status
    is_not_is = true_or_false(@dog.is_altered)
    "has #{is_not_is} been #{spayed_or_neutered}"
  end

  def up_to_date_on_shots
    is_not_is = true_or_false(@dog.is_uptodateonshots)
    "is #{is_not_is} up-to-date on #{posessive_pronoun} shots"
  end

  def true_or_false(true_false)
    true_false ? "" : "not yet"
  end

  def spayed_or_neutered
    @dog.gender=="M" ? "neutered" : "spayed"
  end

  def posessive_pronoun
    male? ? "his" : "her"
  end

  def pronoun
    male? ? "He" : "She"
  end

  def male?
    @dog.gender=="M"
  end

  def search_string_present?
    !(params[:search].nil? || params[:search]&.length&.zero?)
  end

  def is_selected?(id,value)
    selected?(id,value) ? 'selected' : ''
  end

  def is_disabled?(id,value)
    selected?(id,value) ? '' : 'disabled=disabled'
  end

  def is_selected_search?(value)
    selected_search?(value) ? 'selected' : ''
  end

  def is_disabled_search?(value)
    selected_search?(value) ? '' : 'disabled=disabled'
  end

  def size_abbrev(size)
    case size
    when 'small'
      'SM'
    when 'medium'
      'M'
    when 'large'
      'L'
    when 'extra large'
      'XL'
    else
      ''
    end
  end

  private
  def selected?(id,value)
    (@filter_params[id]&.is_a?(Array) && @filter_params[id]&.include?(value.to_s)) ||
      (@filter_params[id]&.is_a?(String) && @filter_params[id] == value.to_s)
  end

  def selected_search?(value)
    @filter_params['search_field_index'] == value
  end
end
