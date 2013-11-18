class HipchatNotifyJob < BaseJob

  def perform(message, format='text')
    begin
      client = HipChat::Client.new(Settings.hipchat.api_key)
      result = client[Settings.hipchat.room].send('AdmoCMS', message, message_format: format)
    rescue
      Bugsnag.notify "HipchatNotifyJob failed to notify HipChat"
    end
  end
end
