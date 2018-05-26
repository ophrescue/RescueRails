module DogsListHelper
  def create_many_dogs
    FactoryBot.create_list(:breed, 30)
    # it's a workaround for TravisCI sorting weirdness.
    # It doesn't handle spaces inside names as expected
    # (expected means ' '< 'x')
    Dog.all.each do |dog|
      dog.update_attribute(:name, dog.name.gsub(/\s/,'').titlecase )
    end
    # make sure there are some terriers for the filter-by-breed spec
    FactoryBot.create(:dog, name: "Trouble")
    FactoryBot.create(:dog, name: "Troubador")
    FactoryBot.create(:dog, name: "Trouper")
    FactoryBot.create_list(:terrier, 5)
    FactoryBot.create_list(:dog, 25)
  end

  def tracking_ids
    page.all('#dogs .dog .tracking_id').map(&:text).map(&:to_i)
  end

  def dog_names
    page.all('#dogs .dog .name a').map(&:text)
  end

  def intake_dates
    page.all('#dogs .dog .intake_date').map(&:text).map{|d| Date.strptime(d, "%m/%d/%y")}
  end

  def statuses
    page.all('#dogs .dog .status').map(&:text)
  end

  def ages
    page.all('#dogs .dog .age').map(&:text)
  end

  def breeds
    page.all('#dogs .dog .breed').map(&:text)
  end

  def filter_by_age(age)
    js = "$('#ageSelect').multiselect('select',['#{age}'])"
    page.execute_script(js)
  end

  def filter_by_breed(string)
    fill_in('is_breed', with: 'terr')
  end
end
