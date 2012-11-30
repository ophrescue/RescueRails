class PagesController < ApplicationController
  def home
    @title = "All breed dog rescue based in VA, MD, DC and South Central PA"
  end
  
  def guide
    @title = "Adoption Guide"
  end

  def aboutus
    @title = "About Us"
  end
  
  def contact
    @title = "Contact Us"
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
  
  def adoptprocess
    @title = "Adoption Process"
  end
  
  def resources
    @title = "Resources for Adopters"
  end
  
  def volunteer
    @title = "Volunteer Opportunities"
  end

  def puppyguide
    @title = "Guide for Puppies"
  end

  def shopping
    @title = "New Dog Shopping List"
  end

end
