require 'spec_helper'

describe Template do
  describe '#enabled?' do
    before :each do
      @template = create(:template)
    end

    context "when status is set to 'enabled'" do
      before :each do
        @template.status = 'enabled'
      end

      it 'returns true' do
        @template.enabled?.should == true
      end
    end

    context "when status is set to 'disabled'" do
      before :each do
        @template.status = 'disabled'
      end

      it 'returns false' do
        @template.enabled?.should == false
      end
    end
  end
end