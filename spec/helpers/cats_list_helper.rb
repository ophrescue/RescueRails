module CatsListHelper
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

  def cats_list
    ids = page.all('#manager_cats .cat a .id').map(&:text)
    names = page.all('#manager_cats .cat a .name').map(&:text)
    breeds = page.all('#manager_cats .cat .breed').map(&:text)
    ids.zip(names,breeds)
  end

  def select_search_by(attribute)
    page.find('#search_field_index ul>li>label>span.filter_option', text: attribute).click
  end

  def create_many_cats
    30.times do
      # create_list can produce duplicates
      FactoryBot.create(:breed)
    end
    # make sure there are some terriers for the filter-by-breed spec
    FactoryBot.create(:cat, name: "Trouble")
    FactoryBot.create(:cat, name: "Troubador")
    FactoryBot.create(:cat, name: "Trouper")
    5.times do |i|
      FactoryBot.create(:tabby, name: "Notfido_#{i}")
    end
    25.times do |i|
      FactoryBot.create(:cat, name: "Fido_#{i}")
    end
  end

  def tracking_ids
    page.all('#manager_cats .cat .id').map(&:text).map{ |id| id.match(/\d*$/)[0] }.map(&:to_i)
  end

  def cat_names
    page.all('#manager_cats .cat a .name').map(&:text)
  end

  def intake_dates
    page.all('#manager_cats .cat .intake_date').map(&:text).map{ |d| Date.strptime(d, "%m/%d/%y") }
  end

  def statuses
    page.all('#manager_cats .cat .status').map(&:text)
  end

  def ages
    page.all('#manager_cats .cat .age').map(&:text)
  end

  def breeds
    page.all('#manager_cats .cat .breed').map(&:text)
  end

  def filter_by(attribute, value)
    id = attribute=='flags' ? "has_flags" : "is_#{attribute}"
    page.find("##{id} button").click
    page.find("##{id} .dropdown-menu li._#{value} .filter_option").click
  end

end
