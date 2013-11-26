class TemplateAppCopier
  def self.copy(template, account, app_name)
    app = App.new
    app.name = app_name
    app.admo_account = account
    app.pod = template.pod
    app.pod_name = template.pod_name
    app.template = template
    app
  end
end
