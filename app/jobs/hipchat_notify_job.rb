class HipchatNotifyJob < BaseJob

  def perform(message, format='text')
     client = HipChat::Client.new(Settings.hipchat.api_key)
     result = client[Settings.hipchat.room].send('AdmoCMS', message, message_format: format)
  end
end
