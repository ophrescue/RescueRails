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
      
end
