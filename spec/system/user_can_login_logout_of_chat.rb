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
end
