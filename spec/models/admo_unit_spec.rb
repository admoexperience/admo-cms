require 'spec_helper'

describe AdmoUnit do
  before do
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
    Settings.pubnub.subscribe_key = "my-sub-key"
    @unit.config = {'1' => 'value', '2'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value', '2'=> 'value2', 'pubnub_subscribe_key'=> 'my-sub-key'})
  end

  it "Config can override global config settings" do
    Settings.pubnub.subscribe_key = "my-sub-key"
    @unit.config = {'1' => 'value', 'pubnub_subscribe_key'=> 'value2'}
    @unit.get_config.should eq({'1' => 'value','pubnub_subscribe_key'=> 'value2'})
  end
end
