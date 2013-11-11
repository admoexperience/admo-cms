object false # custom node, no explicit object
node :apps do
  @apps.map do |app|
    { name: app.name, updated_at: app.updated_at, pod_checksum: app.pod_checksum, pod_url: app.pod.remote_url(expires: 5.hours.from_now, scheme: 'https') }
  end
end
