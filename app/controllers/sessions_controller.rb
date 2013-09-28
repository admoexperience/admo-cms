class SessionsController < ApplicationController
  def create

    access_token = auth_hash[:credentials][:token]
    access_token_secret = auth_hash[:credentials][:secret]

    session = DropboxSession.new(Settings.dropbox.key, Settings.dropbox.secret)
    session.set_access_token(access_token, access_token_secret)

    #Verify that they actually work :) being parinoid
    client = DropboxClient.new(session)
    puts client.account_info.inspect
    current_user.admo_account.update_attributes!(dropbox_session_info: session.serialize())

    render :text=>""
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
