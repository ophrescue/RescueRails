class PagesController < ApplicationController
  def home
    @title = "All breed dog rescue based in Virgina and Maryland"
  end
  
  def aboutus
    @title = "About Us"
  end
  
  def contributers
    @title = "Contributers"
  end
  
  def foster
    @title = "Fostering Opportunities"
  end
  
  def fosterfaq
    @title = "Foster Frequently Asked Questions"
  end
  
  def newsletter
    @title = "Newsletter"
  end
  
  def process
    @title = "Adoption Process"
  end
  
  def resources
    @title = "Resources for Adopters"
  end
  
  def volunteer
    @title = "Volunteer Opportunities"
  end

end
