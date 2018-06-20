module DogsListHelper
  def search_by(field, search_string)
    click_button("Search")
    select_search_by(field)
    page.find('input#search').set(search_string)
    page.find('#search_icon').click
  end

  def filter_info
    page.find('#filter_info').text
  end

  def sort_by(field)
    click_button("Sort")
    page.find("#filter_controls #sort .dropdown-menu li._#{field} span.filter_option").click
  end

  def dogs_list
    ids = page.all('#manager_dogs .dog a .id').map(&:text)
    names = page.all('#manager_dogs .dog a .name').map(&:text)
    breeds = page.all('#manager_dogs .dog .breed').map(&:text)
    ids.zip(names,breeds)
  end

  def select_search_by(attribute)
    page.find('#search_field_index ul>li>label>span.filter_option', text: attribute).click
  end

  def create_many_dogs
    30.times do
      # create_list can produce duplicates
      FactoryBot.create(:breed)
    end
    # make sure there are some terriers for the filter-by-breed spec
    FactoryBot.create(:dog, name: "Trouble")
    FactoryBot.create(:dog, name: "Troubador")
    FactoryBot.create(:dog, name: "Trouper")
    5.times do
      FactoryBot.create(:terrier)
    end
    25.times do |i|
      FactoryBot.create(:dog, name: "Fido_#{i}")
    end
  end

  def tracking_ids
    page.all('#manager_dogs .dog .id').map(&:text).map{|id| id.match(/\d*$/)[0] }.map(&:to_i)
  end

  def dog_names
    page.all('#manager_dogs .dog a .name').map(&:text)
  end

  def intake_dates
    page.all('#manager_dogs .dog .intake_date').map(&:text).map{|d| Date.strptime(d, "%m/%d/%y")}
  end

  def statuses
    page.all('#manager_dogs .dog .status').map(&:text)
  end

  def ages
    page.all('#manager_dogs .dog .age').map(&:text)
  end

  def breeds
    page.all('#manager_dogs .dog .breed').map(&:text)
  end

  def filter_by(attribute, value)
    id = attribute=='flags' ? "has_flags" : "is_#{attribute}"
    page.find("##{id} button").click
    page.find("##{id} .dropdown-menu li._#{value} .filter_option").click
  end

end
