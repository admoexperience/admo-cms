class PubnubPushJob < BaseJob

  def perform(chanel_token, message)
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
