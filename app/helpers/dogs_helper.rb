module DogsHelper
  def validation_class_for(f,field)
    'is-invalid' if f.object.errors.messages[field].any?
  end

  def validation_error_message_for(f,field)
    message = f.object.errors.messages[field].first || client_validation_message_for(field)
    "#{field.to_s.humanize(keep_id_suffix: true)} #{message}"
  end

  def client_validation_message_for(field)
    case field
    when :name
      "cannot be blank"
    when :tracking_id
      "must be numeric"
    when :status
      "must be selected"
    when :content
      "cannot be blank"
    end
  end

  def age_filter_active?
    @filter_params && @filter_params["is_age"] && !@filter_params["is_age"].empty?
  end

  def status_filter_active?
    @filter_params && @filter_params["is_status"] && !@filter_params["is_status"].empty?
  end

  def size_filter_active?
    @filter_params && @filter_params["is_size"] && !@filter_params["is_size"].empty?
  end

  def flag_filter_active?
    @filter_params && @filter_params["has_flags"] && !@filter_params["has_flags"].empty?
  end

  def filter_active?
    [age_filter_active?, status_filter_active?, size_filter_active?, flag_filter_active?].any?
  end

  def selected_flags
    @filter_params && @filter_params["has_flags"] && (Dog::FILTER_FLAGS.as_options.slice(*@filter_params["has_flags"])).values
  end

  def selected_sizes
    @filter_params && @filter_params["is_size"] && (Dog::SIZES.as_options.slice(*@filter_params["is_size"])).values
  end

  def selected_ages
    @filter_params && @filter_params["is_age"] && (Dog::AGES.as_options.slice(*@filter_params["is_age"])).values
  end

  def selected_statuses
    @filter_params && @filter_params["is_status"] && (Dog::STATUSES.as_options.slice(*@filter_params["is_status"])).values
  end

  def selected_sort
    if @filter_params && @filter_params[:sort]
      [Sortable::SORT_FIELDS[@filter_params[:sort].to_sym]]
    else
      []
    end
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
    !search_active? && !sort_active? && !filter_active?
  end

  def sort_active?
    @filter_params['sort'] != 'tracking_id'
  end

  def search_string_present?
    !(params[:search].nil? || params[:search]&.length&.zero?)
  end

  def is_selected?(id, text)
    # e.g. id= 'has_flags' text='No Dogs'
    @filter_params && @filter_params[id.to_sym] && @filter_params[id.to_sym].include?(text.to_s)
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
