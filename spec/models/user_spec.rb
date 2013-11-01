require 'spec_helper'

describe User do
  context "when a new user is created" do
    context "when all the information is entered correctly" do
      before :each do
        @user1 = create(:user)
      end

      it "creates a new account for the user" do
        @user1.admo_account.should be_an(AdmoAccount)
      end

      it "adds the new account to the user's accounts list" do
        @user1.accounts.size.should equal(1)
        @user1.accounts.first.should == @user1.admo_account
      end

      it "assings the company name to the new account" do
        @user1.admo_account.name.should eq(@user1.company_name)
      end
    end

    context "when an account of the given name already exists" do
      before :each do
        @user1 = create(:user)
      end

      it "adds the user's name to the company to avoid duplicates" do
        @user2 = build(:user)
        @user2.company_name = @user1.company_name
        @user2.save!
        @user2.admo_account.name.should eq("#{@user1.company_name} (#{@user2.first_name} #{@user2.last_name})")
      end
    end
  end
end
