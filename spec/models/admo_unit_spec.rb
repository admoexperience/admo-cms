require 'spec_helper'

describe AdmoUnit do
  before do
    Settings.pubnub.subscribe_key = "my-sub-key"
    @unit = create(:admo_unit)
  end
  it "Should update the last check in to now once you check in" do
    @unit.last_checkin.should be_nil
    Timecop.freeze(Time.now) do
      @unit.checkin('doesntmatter')
      @unit.last_checkin.should eq Time.now
    end
  end

  it "Config options should include global settings as well" do
    @unit.config = {'1' => 'value', '2'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value', '2'=> 'value2', 'pubnub_subscribe_key'=> 'my-sub-key'})
  end

  it "Config can override global config settings" do
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2'})
  end

  it "Account config is added to unit" do
    account = create(:admo_account)
    @unit.admo_account = account
    account.config = {'account'=> 'myaccount'}
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2','account'=> 'myaccount'})
  end

  it "Account config is added to unit and can be overriden by unit" do
    account = create(:admo_account)
    @unit.admo_account = account
    account.config = {'account'=> 'myaccount'}
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount'})
  end

  it "Account config is added to unit and can be overriden by unit" do
    @unit.admo_account = nil
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2','account'=> 'unitaccount'})
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

    @unit.checkin('doesntmatter')
    @unit.online?.should eq true


  end
end
