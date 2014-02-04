class Company

  include DataMapper::Resource

  has n, :tags, :through => Resource
  has n, :benefits
  has n, :jobs

  property :id, Serial, :required => true
  property :name, Text, :required => true
  property :avatar, String
  property :size, String
  property :status, String
  property :founded, Integer
  property :url, String
  property :company_id, String
end

