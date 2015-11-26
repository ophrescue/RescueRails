module ApplicationHelper
  def logo
    image_tag("logo.png", alt: "Operation Paws for Homes")
  end

  #Return of title on a per-page basis.
  def title
    base_title = "Operation Paws for Homes"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == params[:sort]) ? "current #{params[:direction]}" : nil
    direction = (column == params[:sort] && params[:direction] == "asc") ? "desc" : "asc"
    status = params[:status]
    link_to title, {sort: column, direction: direction, status: status}, {class: css_class}
  end
end
