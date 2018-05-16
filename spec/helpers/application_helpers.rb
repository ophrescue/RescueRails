module ApplicationHelpers
  def flash_error_message
    page.find('.alert.alert-error').text
  end

  def page_heading
    page.find('h1').text
  end
end
