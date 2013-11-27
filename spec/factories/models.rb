FactoryGirl.define do
  sequence :name do |n|
      "name_#{n}"
  end

  sequence :first_name do |n|
      "first_name_#{n}"
  end

  sequence :last_name do |n|
      "last_name_#{n}"
  end

  sequence :email do |n|
      "email_#{n}@example.com"
  end

  sequence :company_name do |n|
      "company_#{n}@example.com"
  end

  factory :admo_unit do
    config({'key1'=> 'value1', 'key2'=>'value2'})
    name
    admo_account
  end

  factory :admo_account do
    name
  end

  factory :admo_screenshot do
    image File.new("#{Rails.root}/spec/test.png")
    admo_unit
  end

  factory :app do
    name
    admo_account
  end

  factory :template do
    name
  end

  factory :content do
    key "key"
    app
  end

  factory :user do
    first_name
    last_name
    email
    password "1234"
    company_name
  end

  factory :client_version do
    sequence(:number) {|n| "1.#{n}" }
    admo_unit
  end
end
