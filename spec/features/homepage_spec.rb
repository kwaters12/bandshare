require 'spec_helper'

feature "Homepage" do

  include Warden::Test::Helpers

  before (:each) do
    @current_user = User.create!(email: 'email@example.com', password: 'password', profile_name: 'the_dude')
    login_as(@current_user, :scope => :user)
  end

  scenario "User first visits the homepage" do
    visit "/"
    expect(page).to have_content("Add your Band")
  end 

  scenario "User can add a band" do
   
    visit "/"
    visit "bands/new"
    expect(current_path).to eq(new_band_path)
    # fill_in 'Name', with: 'DeathScream'
    # fill_in 'Genres', with: 'rock, rap'
    # fill_in 'Links', with: 'www.youcloud.com'
    # fill_in 'Address', with: '66 McRae Blvd., Detroit'
    # click_on 'Add'
    # expect(page).to have_content('Thanks!')
  end 
end