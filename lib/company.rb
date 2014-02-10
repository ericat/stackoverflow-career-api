class Company

  include DataMapper::Resource
  include Grape::Entity::DSL

  entity do
    expose :name
    expose :avatar
    expose :size
    expose :status
    expose :founded
    expose :url
    expose :company_id
  end

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
  property :created_at, Time
  property :scraping_round, Integer
end

