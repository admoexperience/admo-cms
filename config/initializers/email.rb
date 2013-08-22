 if Settings.email && Settings.email.password
  Rails.logger.info "Using #{Settings.email.user_name}"
  ActionMailer::Base.default_url_options = { :protocol => 'https', :host => Settings.general.hostname }
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.perform_deliveries = true
  ActionMailer::Base.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true,  
    :address            => Settings.email.smtp_hostname,
    :port               => Settings.email.smtp_port,
    :domain             => Settings.email.smtp_domain, #you can also use google.com
    :authentication     => :plain,
    :user_name          => Settings.email.user_name,
    :password           => Settings.email.password
  }
end