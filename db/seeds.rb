# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Admin.all.count
  Admin.create!(email: 'david@fireid.com', password: '1234')
end

account = AdmoAccount.first
unless account
  account = AdmoAccount.create!(name: 'Demo')
end

App.destroy_all

app = App.first
unless app
  config = {
      top_left:{title: 'Avatar', description:'A paraplegic Marine dispatched to the moon Pandora on a unique mission becomes torn between following his orders and protecting the world he feels is his home.'},
      top_right:{title: 'G.I Joe Retaliation', description:'The G.I. Joes are not only fighting their mortal enemy Cobra; they are forced to contend with threats from within the government that jeopardize their very existence.'},
      bottom_left:{title: 'Quartet', description: "At a home for retired musicians, the annual concert to celebrate Verdi's birthday is disrupted by the arrival of Jean, an eternal diva and the former wife of one of the residents."},
      bottom_right:{title: 'The Impossible', description:"The story of a tourist family in Thailand caught in the destruction and chaotic aftermath of the 2004 Indian Ocean tsunami."},
  }
  app = App.create!(name: 'DemoApp', admo_account: account, config: config)

  config.each do |key, value|
    image_file =File.new("#{Rails.root}/app/assets/images/demo-image.jpg")
    Content.create!(app: app, value: image_file, key: "images/#{key}.jpg" )
    Content.create!(app: app, key: "images/#{key}.webm" )
  end
end


#AdmoUnit.destroy_all
unless AdmoUnit.all.count >= 5
  image_file =File.new("#{Rails.root}/app/assets/images/demo-screenshot.png")
  unit = AdmoUnit.create!(name: "Inside" , admo_account: account,
      address: 'CBD', city:'Cape Town', state: 'Western Cape',
      latitude: -33.91886215152598,longitude: 18.420917987823486,
      last_checkin: Time.now
  )
  AdmoScreenshot.create!(image: image_file, admo_unit: unit)

  unit = AdmoUnit.create!(name: "Outside" , admo_account: account,
    address: 'Milnerton', city:'Cape Town', state: 'Western Cape',
    latitude: -33.91886215152518,longitude: 18.420917987823416,
    last_checkin: Time.now
  )
  AdmoScreenshot.create!(image: image_file, admo_unit: unit)

  5.times do |i|
    unit = AdmoUnit.create!(name: "Demo #{i+1}" , admo_account: account,
      address: 'Techno Park', city:'Stellenbosch', state: 'Western Cape',
      latitude: -33.96842016198478,longitude: 18.843483924865723,
      last_checkin: Time.now
    )
    AdmoScreenshot.create!(image: image_file, admo_unit: unit)
  end
end

User.destroy_all

user = User.first
unless user
  user = User.new(email:'demo@admoexperience.com', password:'demo12345', admo_account: account)
  user.skip_confirmation!
  user.save!
end


