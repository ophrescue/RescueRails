module DogsHelper

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
end
