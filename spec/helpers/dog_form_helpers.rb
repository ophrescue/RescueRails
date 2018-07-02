module DogFormHelpers
  def validation_error_message_for(field_id)
    field = ".//input[@id='dog_#{field_id}']"
    form_group = "ancestor::div[contains(@class,'form-group')]"
    error_message = ".//div[contains(@class,'invalid-feedback')]"
    page.find(:xpath, field).find(:xpath, form_group).find(:xpath, error_message, visible: false)
  end

  def submit_button_form_error_message
    page.find('.actions .invalid-feedback', visible: false)
  end
end
