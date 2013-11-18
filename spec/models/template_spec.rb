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

  describe '#copied_by_user?' do
    before :each do
      @account = create(:admo_account)
      @user = create(:user, admo_account: @account)
      @template = create(:template)
    end

    it 'returns true if the user has an app copied from the template' do
      @app = create(:app, admo_account: @account, template: @template)
      @template.copied_by_user?(@user).should be_true
    end

    it 'returns false if the user does not have an app copied from the template' do
      @template.copied_by_user?(@user).should be_false

      @app = create(:app, admo_account: @account, template: @template)
      @app.destroy
      @account.reload

      @template.copied_by_user?(@user).should be_false
    end

    it 'raises an error if you pass in nil or not a user' do
      expect { @template.copied_by_user?(nil) }.to raise_error
      expect { @template.copied_by_user?(@template) }.to raise_error
    end
  end
end
