class PubnubPushJob
  include SuckerPunch::Job

  def perform(chanel_token, message)
    #Only send push notifications in prod mode
    return unless Rails.env.production?

    Rails.logger.debug "Publishing event to pubnub on background job"

    pubnub = Pubnub.new(
      :publish_key=> Settings.pubnub.publish_key,
      :subscribe_key=> Settings.pubnub.subscribe_key,
      :secret_key    => nil,    # optional, if used, message signing is enabled
      :cipher_key    => nil,    # optional, if used, encryption is enabled
      :ssl           => false     # true or default is false
    )

    pubnub.publish({
      :channel => chanel_token,
      :message => message,
      :callback => lambda { |message| }
    })
  end
end
