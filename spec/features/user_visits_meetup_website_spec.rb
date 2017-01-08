require 'spec_helper'

feature "User visits the Meetup Website" do
  let(:user) do
    User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
  end

  scenario "User visits the homepage" do
    meetup = Meetup.create!({
      name: 'Dog',
      location: 'Moon',
      description: 'Fly me to the moon and let me play among the stars.',
      creator_id: 1
    })

    visit '/meetups'

    expect(page).to have_content "#{meetup.name}"
  end

  scenario "User visits a Meetup's page" do
    visit '/'
    user = User.create(
      provider: "github",
      uid: "1",
      username: "jarlax1",
      email: "jarlax1@launchacademy.com",
      avatar_url: "https://avatars2.githubusercontent.com/u/174825?v=3&s=400"
    )
    sign_in_as user

    meetup = Meetup.create!({
      name: 'Dog',
      location: 'Moon',
      description: 'Fly me to the moon and let me play among the stars.',
      creator_id: 1
    })

    visit ('/meetups/' + meetup.id.to_s)

    expect(page).to have_content "#{meetup.name}"
    expect(page).to have_content "#{meetup.location}"
    expect(page).to have_content "#{meetup.description}"
  end
end
