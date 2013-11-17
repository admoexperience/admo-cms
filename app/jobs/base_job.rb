class BaseJob
  include SuckerPunch::Job

  def process(*args, &block)
    #Only send push notifications in prod mode
    log_debug "Added #{self.class.to_s} job"
    #return unless Rails.env.production?

    begin
     async.perform(*args, &block)
    rescue Exception => e
      Bugsnag.notify(e)

      log_error(e.backtrace.join("\n"))
      log_error "************************"
      log_error "Exception: " + e.class.to_s + " - " + e.inspect

      log_error "Unexpected error processing #{self.class.to_s}: #{e.inspect}, #{e.backtrace}"
    ensure
      Mongoid.default_session.disconnect
    end
  end

  def log_debug(text)
     Rails.logger.debug text
  end

  def log_error(text)
     Rails.logger.error text
  end
end
