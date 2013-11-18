class MixpanelApi

  def initialize(config)
    @client = Mixpanel::Client.new(config)
  end

  def total_interactions
    data = daily_interactions
    return 0 if data.blank?
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
    #if there aren't any return a blank list
    data[:values][:undefined] || {}
  end

  def total_interactions_by_host
    data = @client.request('events/properties', {
      event:     'startInteractionSelected',
      name: 'hostName', #hostName
      type:      'unique',
      unit:      'day',
      interval:   30,
    }).with_indifferent_access[:data]
    values_by_host = {}
    data[:values].each do |key, value|
      values_by_host[key] = value.values.inject(:+)
    end
    values_by_host
  end

end
