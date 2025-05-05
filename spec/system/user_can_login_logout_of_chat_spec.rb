require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  context "When user needs to register" do
    before do
      user_at_sign_up_page
    end

    it "allows user to sign up" do
      user_inputs_correct_info_for_register
      user_signs_up

      user_is_redirected_to_homepage_after_login
    end

    it "doesn't allow user to sign up when passwords don't match" do
      user_uses_wrong_password
      user_signs_up

      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it "doesn't allow user to sign up for invalid email format" do
      user_uses_invalid_email
      user_signs_up

      expect(page).to have_content("Email is invalid")
    end

    it "doesn't allow user to sign up when required fields are blank" do
      user_signs_up

      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Username can't be blank")
    end

    it "doesn't allow user to sign up when password is too short" do
      user_uses_too_short_password
      user_signs_up

      expect(page).to have_content("Password is too short")
    end
  end

  context "When the user already has an account" do
    before do
      user_visits_login_page
      User.create!(email: 'test@test.test', username: 'testuser', password: 'password')
    end

    it "allows user to log in" do
      user_enters_correct_info_for_log_in
      user_logs_in

      expect_successful_login
    end

    it "allows user to log out after logging in" do
      user_enters_correct_info_for_log_in
      user_logs_in
      user_logs_out

      expect_successful_logout
    end

    it "doesn't allow login with invalid email" do
      user_enters_wrong_email
      user_logs_in

      expect_failed_login
    end

    it "doesn't allow login with invalid password" do
      user_enters_wrong_password
      user_logs_in

      expect_failed_login
    end

    it "doesn't allow login with blank" do
      user_logs_in

      expect_failed_login
    end
  end

  # METHOD
  def user_at_sign_up_page
    visit '/users/sign_up'
  end

  def user_inputs_correct_info_for_register
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
  end

  def user_uses_wrong_password
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtesttest'
  end

  def user_uses_invalid_email
    fill_in 'Email', with: 'invalid'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
  end

  def user_uses_too_short_password
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'test'
    fill_in 'Password confirmation', with: 'test'
  end

  def user_signs_up
    click_button 'Sign up'
  end

  def user_is_redirected_to_homepage_after_login
    expect(page).to have_content('Welcome')
  end

  def user_visits_login_page
    visit '/users/sign_in'
  end

  def user_enters_correct_info_for_log_in
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
  end

  def user_enters_wrong_email
    fill_in 'Email', with: 'invalid@invalid.invalid'
    fill_in 'Password', with: 'password'
  end

  def user_enters_wrong_password
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'invalid'
  end

  def user_logs_in
    click_button 'Log in'
  end

  def user_logs_out
    click_button 'Sign out'
  end

  def expect_successful_login
    expect(page).to have_content('Welcome')
  end

  def expect_successful_logout
    expect(page).to have_content('Log in')
  end

  def expect_failed_login
    expect(page).to have_content('Log in')
  end
end
