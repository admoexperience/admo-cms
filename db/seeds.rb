# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

unless Admin.first
  Admin.create!(email: 'admin@admoexperience.com', password: 'demo12345')
end

account = AdmoAccount.first
unless account
  account = AdmoAccount.create!(name: 'Demo')
end

App.destroy_all

app = App.first
unless app
  app = App.create!(name: 'DemoApp',pod_name:'dist-demo-app.pod.zip', admo_account: account)
  app = App.create!(name: 'DemoApp2',pod_name:'dist-demo-app2.pod.zip', admo_account: account)
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
  user = User.new(email:'demo@admoexperience.com', password:'demo12345', admo_account: account, company_name: 'usercorp')
  user.accounts << account
  user.skip_confirmation!
  user.save!
end


