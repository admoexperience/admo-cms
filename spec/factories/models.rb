FactoryGirl.define do
  sequence :name do |n|
      "name_#{n}"
  end

  factory :admo_unit do
    config({'key1'=> 'value1', 'key2'=>'value2'})
    name 
  end
end