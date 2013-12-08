class PubnubPushJob < BaseJob

  def perform(chanel_token, message)
    unless Settings.pubnub.publish_key.empty? or Settings.pubnub.subscribe_key.empty?
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
    else
      log_debug("PUBNUB: publish/subscribe keys not set not pushing [#{message}] down [#{chanel_token}]")
    end
  end
end
