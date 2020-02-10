module ApplicationHelpers
  def flash_error_message
    sleep(1)
    page.find('.alert.alert-error').text
  end

  def flash_notice_message
    sleep(1)
    page.find('.alert.alert-notice').text
  end

  def flash_success_message
    sleep(1)
    page.find('.alert.alert-success').text
  end

  def page_heading
    page.find('h1').text
  end

  def find_link_and_click(locator)
    script = <<-JS
      arguments[0].scrollIntoView(true)
    JS

    element = page.find(:link, locator)

    Capybara.current_session.driver.browser.execute_script(script,element.native)

    element.click
  end
end
