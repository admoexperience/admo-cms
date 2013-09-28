require 'spec_helper'

describe MixpanelApi do
  before do
    #Admo-Internal api key "not really production"
    #Useful for testing mixpanel api
    config = {api_key: '3f054085eb8960c5f04b59aa2de0c599', api_secret: '60a975524569d8358344bdd0488ad17a'}
    @api = MixpanelApi.new(config)
  end

  # it "It should display the correct events" do
  #   x = @api.total_interactions
  #   x.should be_a_kind_of(Numeric)
  #   #x.should be 311
  # end

  # it "Should return monthly stats per day of each value" do
  #   total = @api.total_interactions
  #   daily = @api.daily_interactions
  #   calculated = daily.values.inject(:+)
  #   calculated.should be total

  #   #daily.count.should be 30  #30 days of values
  # end

  it "Should split the interactions by pc" do
    #x = @api.total_interactions

    list = @api.total_interactions_by_host
    #{"ADMO-ROOM"=>63, "ADMO-DATAVOICE"=>34, "ADMO-MALAN"=>7}

  end
end
