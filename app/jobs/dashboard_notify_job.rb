class DashboardNotifyJob < BaseJob

  class DashParty
    include HTTParty
    base_uri Settings.dashboard.uri
  end

  def perform(widget, hash_ptions)

    authed_hash = hash_ptions.merge(auth_token: Settings.dashboard.api_key)
    body = authed_hash.to_json
    Rails.logger.debug body

    DashParty.post('/'+widget, :body => body, :options => { :headers => { 'ContentType' => 'application/json' } } )
  end
end
