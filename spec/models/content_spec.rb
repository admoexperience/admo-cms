require 'spec_helper'

describe Content do
  before do
  end
  
  it "Should return correct is_image for values and not for nill" do 

    ['top_left.png','top_left.jpeg','top_left.jpg','top_left.gif'].each do |name|
    content = create(:content, {key: '/var/test/'+name})
    content.is_image.should be_true
    end

    content = create(:content, {key: nil})
    content.is_image.should_not be_true

    content = create(:content, {key: '/var/test/video.mov'})
    content.is_image.should_not be_true
  end
end
