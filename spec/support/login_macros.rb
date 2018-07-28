module LoginMacros
  def fill_and_submit(user)
    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password
    click_button I18n.t("helpers.submit.session.submit")
  end

  def sign_in_as_admin
    admin = FactoryBot.create(:user, :admin)

    sign_in_with(admin.email, admin.password)

    admin
  end

  def sign_in_as_user
    user = FactoryBot.create(:user)

    sign_in_with(user.email, user.password)

    user
  end

  def sign_in_as_inactive_user
    user = FactoryBot.create(:user, :inactive_user)

    sign_in_with(user.email, user.password)

    user
  end
end
