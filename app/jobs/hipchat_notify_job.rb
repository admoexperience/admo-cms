class HipchatNotifyJob < BaseJob

  def perform(message, format='text')
    unless Settings.hipchat.api_key.empty?
       client = HipChat::Client.new(Settings.hipchat.api_key)
       result = client[Settings.hipchat.room].send('AdmoCMS', message, message_format: format)
    else
      log_debug("HIPCHAT: api_key not set not sending [#{message}]")
    end
  end
end
