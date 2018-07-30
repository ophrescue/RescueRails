module DogShowHelper
  def adoptapet_ad
    page.find('#adoptapet_ad').text
  end

  def adoptapet_ad_link
    page.find('#adoptapet_ad a')['href']
  end

  def set_screen_size(screen_size)
    dimensions = screen_size == :small_screen ? [308, 455 ] : [1250, 800]
    window = Capybara.current_session.current_window
    window.resize_to(*dimensions)
  end
end
