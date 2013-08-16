class BaseJob
  include SuckerPunch::Job

  def process(*args, &block)
    #Only send push notifications in prod mode
    Rails.logger.debug "Added #{self.class.to_s} job"
    #return unless Rails.env.production?

    begin
     async.perform(*args, &block)
    rescue Exception => e
      Bugsnag.notify(e)

      Rails.logger.error e.backtrace.join("\n")
      Rails.logger.error "************************"
      Rails.logger.error "Exception: " + e.class.to_s + " - " + e.inspect

      Rails.logger.error "Unexpected error processing #{self.class.to_s}: #{e.inspect}, #{e.backtrace}"
    ensure
      Mongoid.default_session.disconnect
    end
  end
end
