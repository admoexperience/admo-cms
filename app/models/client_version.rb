class ClientVersion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number,              type: String
  field :last_reported_at,         type: Time,     default: lambda {Time.now}

  belongs_to :admo_unit

  validates_format_of :number, with: /\A\d+(?:\.\d+)*\z/

  validates_uniqueness_of :number, :scope=> :admo_unit
  validates_presence_of :admo_unit

  def title
    number
  end
end
