object false # custom node, no explicit object
node :apps do
  @apps.map do |app|
    { name: app.name, updated_at: app.updated_at,pod_name: app.pod_name, pod_checksum: app.pod_checksum, pod_url: app.pod_public_url}
  end
end
