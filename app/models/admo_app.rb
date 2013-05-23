class AdmoApp
  include Mongoid::Document
  include Mongoid::Timestamps


  field :name,             type: String
  field :description,      type: String

  validates_uniqueness_of :name
  validates_presence_of :name
end
