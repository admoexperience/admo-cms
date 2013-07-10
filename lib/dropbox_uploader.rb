class DropboxUploader

   ACCESS_TYPE = :dropbox

  def initialize(session_info)
    @session = DropboxSession.deserialize(session_info)
    @client = DropboxClient.new(@session, ACCESS_TYPE)
  end


  def upload_file(path,file,name)
    date = Time.now.strftime("%Y-%m-%d")
    ext =File.extname(name)
    name = Time.now.strftime("%H-%M-%S#{ext}")
    response = @client.put_file(File.join(path,date,name), open(file))
  end
end
