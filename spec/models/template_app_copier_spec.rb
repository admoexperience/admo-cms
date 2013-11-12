require 'spec_helper'

describe TemplateAppCopier do
  describe '#copy' do
    before :each do
      @template = create(:template, pod: File.new("#{Rails.root}/spec/dist-test.pod.zip"))
      @account = create(:admo_account)
      @app = TemplateAppCopier.copy(@template, @account, "MyApp1")
    end

    it 'takes a template, and creates and returns a new app' do
      @app.should be_an(App)

      expect {
        TemplateAppCopier.copy(@template, @account, "MyApp2")
      }.to change(App, :count).by(1)
    end

    describe 'the returned app' do
      it 'has the name that was passed into the copier' do
        @app.name.should == "MyApp1"
      end

      it 'belongs to the account passed in to TemplateAppCopier' do
        @app.admo_account.should == @account
      end

    end

    describe 'the pod file do' do
      it 'has a unique uid' do
        @app.pod_uid.should_not be_nil
        @app.pod_uid.should_not eq(@template.pod_uid)
      end

      it 'has the same hash as the templates pod file' do
        @template.pod_checksum.should eq("0434653354f39cec388c3772fb46accbf9a43ddc3dfa5f34eed8c6c0a06306e6")
        @app.pod_checksum.should eq("0434653354f39cec388c3772fb46accbf9a43ddc3dfa5f34eed8c6c0a06306e6")
      end

      it 'has the same name as the templates pod file' do
        @app.pod_name.should == @template.pod_name
      end
    end
  end
end