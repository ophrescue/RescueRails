module DogsHelper
  def is_selected?(id,value)
    selected?(id,value) ? 'selected' : ''
  end

  def is_disabled?(id,value)
    selected?(id,value) ? '' : 'disabled=disabled'
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
end
