class PagesController < ApplicationController

  before_filter :authenticate, :only => [:status_definitions]

  def home
    @title = "All breed dog rescue based in Virgina, Maryland, Washington DC and South Central PA"
    @events = Event.find(:all,
           :conditions => ["event_date >= ?", Date.today],
           :limit => 5, 
           :order => 'event_date')
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

  def partnerships
    @title = "Partnerships"
  end

  def shelters
    @title = "Partnering Shelters"
  end

  def contribute
    @title = "Contribute"
  end

  def special_funds
    @title = "Special Funds"
  end

  def sponsor
    @title = "Sponsor a Dog"
  end
  
  def other_ways_to_give
    @title = "Other Ways to Give"
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

  def insurance
    @title = "Pet Insurance"
  end
  
  def resources
    @title = "Resources for Adopters"
  end
  
  def volunteer
    @title = "Volunteer"
  end

  def documentary
    @title = "'600 Miles Home' Dog Rescue Documentary"
  end

  def puppyguide
    @title = "Guide for Puppies"
  end

  def shopping
    @title = "New Dog Shopping List"
  end

  def status_definitions
    @hide_topbar = true;
    @title = "Adoption Application Status Definitions"
  end

  def dog_status_definitions
    @hide_topbar = true;
    @title = "Dog Status Definitions"
  end

  def terms
    @title = "Terms and Conditions"
  end

end
