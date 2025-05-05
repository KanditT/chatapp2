require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  context "registration" do
    it "allow users to sign up" do
      user_at_sign_up_page
      user_can_register
      user_enter_submit_to_sign_up

      user_success_to_sign_up
    end

    it "don't allow users to sign up when passwords don't match" do
      user_at_sign_up_page
      user_input_wrong_password
      user_enter_submit_to_sign_up

      expect(page).to have_content("Password confirmation doesn't match Password")
    end

    it "don't allow users to sign up for invalid email format" do
      user_at_sign_up_page
      user_use_invalid_email
      user_enter_submit_to_sign_up

      expect(page).to have_content("Email is invalid")
    end

    it "don't allow users to sign up when required fields are blank" do
      user_at_sign_up_page
      user_enter_submit_to_sign_up

      expect(page).to have_content("Email can't be blank")
      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Username can't be blank")
    end

    it "don't allow users to sign up when password is too short" do
      user_at_sign_up_page
      user_use_too_short_password
      user_enter_submit_to_sign_up

      expect(page).to have_content("Password is too short")
    end
  end

  context "already have account" do
    before do
      User.create!(email: 'test@test.test', username: 'testuser', password: 'password')
    end

    it "allow user to log in" do
      user_at_login_page
      user_can_login
      user_enter_submit_login_page

      expect_successful_login
    end

    it "allow user to log out after logging in" do
      user_at_login_page
      user_can_login
      user_enter_submit_login_page
      user_logs_out

      expect_successful_logout
    end

    it "don't allow login with invalid email" do
      user_at_login_page
      user_enter_wrong_email
      user_enter_submit_login_page

      expect_failed_login
    end

    it "don't allow login with invalid password" do
      user_at_login_page
      user_enter_wrong_password
      user_enter_submit_login_page

      expect_failed_login
    end

    it "don't allow login with blank" do
      user_at_login_page
      user_enter_submit_login_page

      expect_failed_login
    end
  end

  # METHOD
  def user_at_sign_up_page
    visit '/users/sign_up'
  end

  def user_can_register
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
  end

  def user_input_wrong_password
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtesttest'
  end

  def user_use_invalid_email
    fill_in 'Email', with: 'invalid'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
  end

  def user_use_too_short_password
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'test'
    fill_in 'Password confirmation', with: 'test'
  end

  def user_enter_submit_to_sign_up
    click_button 'Sign up'
  end

  def user_success_to_sign_up
    expect(page).to have_content('Welcome')
  end

  def user_at_login_page
    visit '/users/sign_in'
  end

  def user_can_login
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'password'
  end

  def user_enter_wrong_email
    fill_in 'Email', with: 'invalid@invalid.invalid'
    fill_in 'Password', with: 'password'
  end

  def user_enter_wrong_password
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'invalid'
  end

  def user_enter_submit_login_page
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
