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
end
