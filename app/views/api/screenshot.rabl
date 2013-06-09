object false
node :screenshot do
  "#{request.scheme}://#{request.host_with_port}#{@screenshot.image.url}/#{@screenshot.image_name}"
end
