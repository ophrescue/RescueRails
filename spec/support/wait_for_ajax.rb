# thank you Thoughtbot!
# https://robots.thoughtbot.com/automatically-wait-for-ajax-with-capybara
module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    # see http://stackoverflow.com/a/3148506/451893
    # this MAY change to jQuery.ajax.active in a later release
    page.evaluate_script('jQuery.active').zero?
  end

end

RSpec.configure do |config|
  config.include WaitForAjax, type: :feature
end
