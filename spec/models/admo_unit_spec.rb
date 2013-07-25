require 'spec_helper'

describe AdmoUnit do
  it "Should update the last check in to now once you check in" do
    unit = AdmoUnit.new()
    unit.last_checkin.should be_nil
    Timecop.freeze(Time.now) do
      unit.checkin
      unit.last_checkin.should eq Time.now
    end
  end
end
