FactoryGirl.define do
  sequence :name do |n|
      "name_#{n}"
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
    image File.new("#{Rails.root}/test.png")
    admo_unit
  end
end
