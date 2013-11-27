require 'spec_helper'

describe AdmoUnit do
  before do
    Settings.pubnub.subscribe_key = "my-sub-key"
    @unit = create(:admo_unit)
  end
  it "Should update the last check in to now once you check in" do
    @unit.last_checkin.should be_nil
    Timecop.freeze(Time.now) do
      @unit.checkin
      @unit.last_checkin.should eq Time.now
    end
  end

  it "Config options should include global settings as well" do
    @unit.config = {'1' => 'value', '2'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value', '2'=> 'value2', 'pubnub_subscribe_key'=> 'my-sub-key', 'name'=>@unit.name})
  end

  it "Config can override global config settings" do
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2', 'name'=>@unit.name})
  end

  it "Account config is added to unit" do
    account = create(:admo_account)
    @unit.admo_account = account
    account.config = {'account'=> 'myaccount'}
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2','account'=> 'myaccount', 'name'=>@unit.name})
  end

  it "Account config is added to unit and can be overriden by unit" do
    account = create(:admo_account)
    @unit.admo_account = account
    account.config = {'account'=> 'myaccount'}
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount', 'name'=>@unit.name})
  end

  it "Account config is added to unit and can be overriden by unit" do
    @unit.admo_account = nil
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount', 'name'=>@unit.name})
  end


  it " dashboard_enabled feature" do
    @unit.dashboard_enabled.should eq false

    @unit.config = {'dashboard_enabled' => true}
    @unit.dashboard_enabled.should eq true
  end

  it " dashboard_enabled feature should carry over from account" do
    account = create(:admo_account)
    account.config = config = {'dashboard_enabled' => true}
    @unit.admo_account = account
    @unit.dashboard_enabled.should eq true
  end

  it "current_screenshot should be the most recent" do
    old = create(:admo_screenshot)
    old.created_at = 20.minutes.ago
    old.save
    @unit.admo_screenshots << old

    s = create(:admo_screenshot)
    s.created_at = 5.minutes.ago
    s.save
    @unit.admo_screenshots << s
    @unit.current_screenshot.should eq s
  end

  it "Should work out if it is online is_online based on time interval" do
    @unit.last_checkin = nil
    @unit.online?.should eq false

    @unit.last_checkin = 5.minutes.ago
    @unit.online?.should eq true

    @unit.last_checkin = 16.minutes.ago
    @unit.online?.should eq false

    @unit.checkin
    @unit.online?.should eq true
  end

  it "Should clean up all but the most recent 5 screenshot records" do
    first = create(:admo_screenshot)
    @unit.admo_screenshots << first
    @unit.admo_screenshots.count.should eq 1
    6.times do |count|
      @unit.admo_screenshots << create(:admo_screenshot)
      @unit.admo_screenshots.count.should eq(count+2) #Count starts at 0
    end

    @unit.clean_up
    @unit.admo_screenshots.count.should eq 5
    @unit.admo_screenshots.where(id: first.id).first.should eq nil
  end

  it "Should clean up all but the most recent configured screenshot records" do
    max_keep = 8
    config = @unit.config
    config[:screenshot_max_keep] = max_keep
    @unit.config = config
    @unit.save!

    first = create(:admo_screenshot)
    @unit.admo_screenshots << first
    @unit.admo_screenshots.count.should eq 1
    (max_keep+2).times do |count|
      @unit.admo_screenshots << create(:admo_screenshot)
      @unit.admo_screenshots.count.should eq (count+2) #Count starts at 0
    end

    @unit.clean_up
    @unit.admo_screenshots.count.should eq max_keep
    @unit.admo_screenshots.where(id: first.id).first.should eq nil
  end

  it "Should be able to create multiple units with the same name if they are in a different account" do
    @unit.name = "1234"
    @unit.save!

    @unit2 = create(:admo_unit)
    @unit2.admo_account = @unit.admo_account
    @unit2.valid?.should eq true
    @unit2.name = "1234"
    @unit2.valid?.should eq false

    #Units shoult be valid if the accounts change
    @unit2.admo_account = create(:admo_account)
    @unit2.valid?.should eq true
  end

  it 'should pass the name to the unit' do
    @unit.name = "myname"
    @unit.get_config['name'].should eq "myname"
  end


  it 'Should inject analytics into the unit config' do
    account = @unit.admo_account
    account.analytics = {mixpanel_api_key: 'mixpanel_api_key', mixpanel_api_secret: 'mixpanel_api_secret',
mixpanel_api_token: 'mixpanel_api_token'}
    config = @unit.get_config['analytics']
    config['mixpanel_api_key'].should eq "mixpanel_api_key"
    config['mixpanel_api_secret'].should eq nil
    config['mixpanel_api_token'].should eq "mixpanel_api_token"
  end

  it 'creates a new version number if one didnt exsist' do
    @unit.client_versions.count eq(0)
    version = @unit.update_client_version('1.1.1.1')
    version.number.should eq('1.1.1.1')
    @unit.client_versions.count eq(1)
  end

  it 'simply returns current version if already set' do
    version = @unit.update_client_version('1.1.1.1')
    version.number.should eq('1.1.1.1')

    version = @unit.update_client_version('1.1.1.1')
    version.should eq(@unit.client_versions.first)
    @unit.client_versions.count eq(1)
  end

  it 'updates the version number when a new version is passed in' do
    @unit.client_versions << create(:client_version, number:'1.3.3.4')
    new_ver_number = '1.2.3.5'
    version = @unit.update_client_version(new_ver_number)
    version.number.should eq(new_ver_number)
    @unit.client_versions.count eq(2)
  end

  it 'updates the reported at field to current time when unit reports in' do
    ver = create(:client_version)
    ver.last_reported_at = 5.hours.ago
    ver.last_reported_at.should_not eq(Time.now)
    @unit.client_versions << ver
    Timecop.freeze(Time.now) do
      new_version = @unit.update_client_version(ver.number)
      new_version.number.should eq(ver.number)
      new_version.last_reported_at.should eq(Time.now)
    end
  end
end
