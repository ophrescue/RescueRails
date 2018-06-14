module DogsHelper
  def age_filter_active?
    !@filter_params['is_age'].empty?
  end

  def status_filter_active?
    !@filter_params['is_status'].empty?
  end

  def size_filter_active?
    !@filter_params['is_size'].empty?
  end

  def flag_filter_active?
    !@filter_params['has_flags'].empty?
  end

  def selected_flags
    Dog::FILTER_FLAGS.slice(*@filter_params["has_flags"])
  end

  def selected_sizes
    #["small", "medium", "large", "extra large"]
    (Dog::SIZES & @filter_params['is_size']).to_id_and_value_hash
  end

  def sort_field
    Sortable::SORT_FIELDS.slice(@filter_params['sort'].to_sym)
  end

  def search_active?
    search_string.present? && search_field_index.present?
  end

  def search_field_index
    @filter_params['search_field_index']
  end

  def search_string
    @filter_params['search']
  end


  def x_icon
    "<i class='fa fa-lg fa-times text-danger'></i>".html_safe
  end

  def render_if(condition, options)
    if condition
      render options
    end
  end

  def render_unless(condition, options)
    render_if(!condition, options)
  end

  def default_search_sort?
    !search_active? && !sort_active?
  end

  def sort_active?
    @filter_params['sort'] != 'tracking_id'
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
