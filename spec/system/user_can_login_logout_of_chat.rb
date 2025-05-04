require 'rails_helper'

RSpec.describe "User Authentication", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "allows user to sign up, log out, and log in" do
    puts "\nUser can sign up"
    visit '/users/sign_up'

    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
    click_button 'Sign up'
    expect(page).to have_content('Welcome')
    puts "Sign up done"

    puts "\nUser can log out"
    click_button 'Sign out'
    expect(page).to have_content('Log in')
    puts "Sign out done"

    puts "\nUser can log in"
    visit '/users/sign_in'
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'testtest'
    click_button 'Log in'
    expect(page).to have_content('Welcome')
    puts "Login done"
  end

  it "passwords don't match" do
    puts "\nUser can't sign up"
    visit '/users/sign_up'
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtesttest'
    click_button 'Sign up'
    expect(page).to have_content("Password confirmation doesn't match Password")
    puts "passwords don't match"
  end

  it "invalid email format" do
    visit '/users/sign_up'
    fill_in 'Email', with: 'invalid-email'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'testtest'
    fill_in 'Password confirmation', with: 'testtest'
    click_button 'Sign up'
    expect(page).to have_content("Email is invalid")
    puts "invalid email format"
  end

  it "blank fields" do
    visit '/users/sign_up'
    click_button 'Sign up'
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
    expect(page).to have_content("Username can't be blank")
    puts "blank fields"
  end

  it "password below minimum length" do
    visit '/users/sign_up'
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Username', with: 'testtest'
    fill_in 'Password', with: 'test'
    fill_in 'Password confirmation', with: 'test'
    click_button 'Sign up'
    expect(page).to have_content("Password is too short")
    puts "password is too short"
  end
end

describe "User can't login" do
  before do
    driven_by(:rack_test)
    User.create!(email: 'test@test.test', username: 'testuser', password: 'password123')
  end

  it "invalid email" do
    puts "\nUser can't login"
    visit '/users/sign_in'
    fill_in 'Email', with: 'invalid@invalid.invalid'
    fill_in 'Password', with: 'password123'
    click_button 'Log in'
    expect(page).to have_content('Log in')
    puts "invalid email"
  end

  it "invalid password" do
    visit '/users/sign_in'
    fill_in 'Email', with: 'test@test.test'
    fill_in 'Password', with: 'invalidinvalid'
    click_button 'Log in'
    expect(page).to have_content('Log in')
    puts "invalid password"
  end

  it "blank" do
    visit '/users/sign_in'
    click_button 'Log in'
    expect(page).to have_content('Log in')
    puts "blank"
  end
end
