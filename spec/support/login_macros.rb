module LoginMacros
  def sign_in(user)
    visit '/signin'
    fill_in('session_email', with: user.email)
    fill_in('session_password', with: user.password)
    click_button('Sign in')
    expect(page).to have_content('Staff')
    expect(page).to have_no_content('Invalid')
  end
end
