class HipchatNotifyJob
  include SuckerPunch::Job

  def perform(message, format='text')
    #Only send push notifications in prod mode
    
    return unless Rails.env.production?
    
    begin
     client = HipChat::Client.new(Settings.hipchat.api_key)
     result = client[Settings.hipchat.room].send('AdmoCMS', message, message_format: format)
     Rails.logger.debug result.inspect 
    rescue Exception => e
      Bugsnag.notify(e)

      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.error "************************"
      Rails.logger.error "Exception: " + e.class.to_s + " - " + e.inspect

      Rails.logger.error "Unexpected error processing HipchatNotifyJob: #{e.inspect}, #{e.backtrace}"
    ensure
      Mongoid.default_session.disconnect
    end
  end
end
