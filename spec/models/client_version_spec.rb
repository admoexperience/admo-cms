require 'spec_helper'

describe ClientVersion do
  describe 'Client version' do
    it 'Default value for last_set_at time.now' do
      Timecop.freeze(Time.now) do
        version = create(:client_version)
        version.last_reported_at.should eq(Time.now)
      end
    end

    it 'title displays number' do
      version = create(:client_version)
      version.title.should eq(version.number)

      version.number = '1.1.1'
      version.title.should eq('1.1.1')
    end

    it 'Unique version number per unit' do
      version = create(:client_version)
      version.valid?.should be_true

      version2 = create(:client_version)
      version.valid?.should be_true

      version2.admo_unit = version.admo_unit
      version2.number = version.number
      version2.valid?.should be_false
    end

    it 'Client version' do
      version = create(:client_version)
      version.number = '1.1.1.1.11'
      version.valid?.should be_true
      version.number = '1'
      version.valid?.should be_true

      version.number = '112312.1123.13.1.11123'
      version.valid?.should be_true

      version.number = "adsf"
      version.valid?.should be_false

      version.number = "a.1.as."
      version.valid?.should be_false

      version.number = "1.1."
      version.valid?.should be_false

      version.number = ".1."
      version.valid?.should be_false
    end
  end
end
