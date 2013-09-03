desc "This task is called by the Heroku scheduler add-on"
task :update_demo_data => :environment do
  #This is currently a hack because we don't have a "demo env"
  raise 'Demo data can only be run in demo mode' unless Settings.general.hostname.match 'demo'
  
  (AdmoUnit.count/4*3).times do
   unit =  AdmoUnit.offset(rand(AdmoUnit.count)).first
   unit.last_checkin = Time.now.advance(hour: 1)
   unit.save!
  end

end