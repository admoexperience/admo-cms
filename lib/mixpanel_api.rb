class MixpanelApi

  def initialize(config)
    @client = Mixpanel::Client.new(config)
  end

  def total_interactions
    data = daily_interactions
    total = data.values.inject(:+)
    total
  end

  def daily_interactions
    #startInteractionSelected
    data = @client.request('events/properties', {
      event:     'startInteractionSelected',
      name: 'undefined', #hostName
      type:      'unique',
      unit:      'day',
      interval:   30,
    }).with_indifferent_access[:data]
    data[:values][:undefined]
  end

  def get_trailer_selections
  end
end
