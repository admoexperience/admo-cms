class ContentUploaderJob < BaseJob
  def perform(content)
    #Each content has their own worker, since the content might supposed to be uploaded via dropbox or something else.
    content.upload_worker
  end
end
