require 'spec_helper'

feature "Homepage" do
  scenario "User first visits the homepage" do
    visit "/"
    expect(page).to have_content("Add your Band")
  end 

  scenario "User can add a band" do
    visit "/"
    click_on "Add your Band"
    fill_in 'Name', with: 'DeathScream'
    fill_in 'Genres', with: 'rock, rap'
    fill_in 'Links', with: 'www.youcloud.com'
    fill_in 'Address', with: '66 McRae Blvd., Detroit'
    click_on 'Add'
    expect(page).to have_content('Thanks!')
  end 
end