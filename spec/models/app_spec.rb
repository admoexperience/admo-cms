require 'spec_helper'

describe App do
  before do
  end

  it "Should find the correct image with the given key" do
    app = create(:app)


    app.contents << create(:content, {key: '/var/test/top_left.webm'})
    top_left = create(:content, {key: '/var/test/top_left.png'})
    app.contents << top_left
    app.contents << create(:content, {key: '/var/test/a.png'})
    app.contents << create(:content, {key: '/var/test/b.png'})

    img = app.find_image('top_left')
    img.should eq top_left
  end

  it "Should set a checksum of a given file when uploading a pod file" do
    app = create(:app, pod: File.new("#{Rails.root}/spec/dist-test.pod.zip"))
    app.pod_checksum.should eq("0434653354f39cec388c3772fb46accbf9a43ddc3dfa5f34eed8c6c0a06306e6")
  end

  it "Should check that only zip files can be uploaded" do
    expect {
      create(:app, pod: File.new("#{Rails.root}/spec/test.png"))
    }.to raise_error(Mongoid::Errors::Validations)
    #Pod mime type is incorrect. It needs to be 'application/zip', but was 'image/png'
  end
end
