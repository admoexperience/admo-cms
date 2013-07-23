class DropboxUploader

   ACCESS_TYPE = :dropbox

  def initialize(session_info)
    @session = DropboxSession.deserialize(session_info)
    @client = DropboxClient.new(@session, ACCESS_TYPE)
  end


  def upload_file(path,file,name)
    date = Time.now.strftime("%Y-%m-%d")
    ext =File.extname(name)
    base_name = File.basename(name, ext)
    #Strip any thing that isn't lower case chars/numbers
    new_name = name.downcase.gsub(/[^0-9a-z\.]/, '')
    file_name = Time.now.strftime("%H-%M-%S_#{new_name}")
    response = @client.put_file(File.join(path,base_name,date,file_name), open(file))
    Rails.logger.info response.inspect
  end
end
