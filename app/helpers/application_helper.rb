module ApplicationHelper
  def logo
    image_tag('logo.png', alt: 'Operation Paws for Homes')
  end

  def title
    @title ||= I18n.t("title.#{controller_name}.#{action_name}")

    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def base_title
    'Operation Paws for Homes'
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == params[:sort]) ? "current #{params[:direction]}" : nil
    direction = (column == params[:sort] && params[:direction] == 'asc') ? 'desc' : 'asc'
    status = params[:status]
    link_to title, { sort: column, direction: direction, status: status }, { class: css_class }
  end
end
