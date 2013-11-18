class SyncTemplatesJob < BaseJob
  def perform(template)
    pod_file = template.pod.tempfile
    pod_name = template.pod_name
    apps = template.apps

    if Rails.env.production?
      HipchatNotifyJob.new.perform("Syncing template <b>#{template.name}</b> to <b>#{apps.size}</b> accounts", format='html')
    end

    apps.each do |app|
      log_debug  "Proccessing #{app.name} for #{app.admo_account.name}"
      app.pod = pod_file
      app.pod_name = pod_name
      app.save!
    end
  end
end
