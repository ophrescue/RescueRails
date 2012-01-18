module ApplicationHelper
  
  def logo
    logo = image_tag("logo.png", :alt => "Operation Paws for Homes")
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

    
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    sort_updown = (sort_direction == "asc") ? "Up" : "Down"
    css_class = (column == sort_column) ? "headerSort#{sort_updown}" : nil  
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
      
end
