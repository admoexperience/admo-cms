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
    #Depricated use of hostname
    #TODO(david) upgrade this when we no longer need to display legacy data
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

    data = @client.request('events/properties', {
      event:     'startInteractionSelected',
      name: 'unitName', #hostName
      type:      'unique',
      unit:      'day',
      interval:   30,
    }).with_indifferent_access[:data]
    data[:values].each do |key, value|
      values_by_host[key] = value.values.inject(:+)
    end

    #Values should have record values that either have unitName or hostName never both
    values_by_host.reject {|key,v| key == 'undefined'}
  end

end
