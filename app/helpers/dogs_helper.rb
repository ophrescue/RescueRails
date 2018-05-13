module DogsHelper
  def dog_index_page_title
    session[:mgr_view] ? 'Dog Manager' : 'Our Dogs'
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
end
