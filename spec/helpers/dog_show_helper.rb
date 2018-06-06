module DogShowHelper
  def adoptapet_ad
    page.find('#adoptapet_ad').text
  end

  def adoptapet_ad_link
    page.find('#adoptapet_ad a')['href']
  end
end
