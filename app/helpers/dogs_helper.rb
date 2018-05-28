module DogsHelper
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
