require 'spec_helper'

describe TemplateAppCopier do
  describe '#copy' do
    before :each do
      @template = create(:template, pod: File.new("#{Rails.root}/spec/dist-test.pod.zip"))
      @account = create(:admo_account)
      @app = TemplateAppCopier.copy(@template, @account, "MyApp1")
      @app.save!
    end

    it 'takes a template, and creates and returns a new app' do
      @app.should be_an(App)

      expect {
        template = create(:template, pod: File.new("#{Rails.root}/spec/dist-test.pod.zip"))
        account = create(:admo_account)
        app = TemplateAppCopier.copy(template, account, "MyApp2")
        app.save!
      }.to change(App, :count).by(1)
    end

    describe 'the returned app' do
      it 'has the name that was passed in' do
        @app.name.should == "MyApp1"
      end

      it 'belongs to the account that was passed in' do
        @app.admo_account.should == @account
      end

      it 'belongs to the template that was passed in' do
        @app.template.should == @template
        @template.apps.should include(@app)
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
