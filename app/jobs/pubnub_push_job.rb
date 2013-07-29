class PubnubPushJob
  include SuckerPunch::Job

  def perform(chanel_token, message)
    #Only send push notifications in prod mode
    return unless Rails.env.production?

    begin
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
    rescue Exception => e
      Bugsnag.notify(e)

      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.error "************************"
      Rails.logger.error "Exception: " + e.class.to_s

      Rails.logger.error "Unexpected error processing PubnubPushJob: #{e.inspect}, #{e.backtrace}"
    ensure
      Mongoid.default_session.disconnect
    end
  end
end
