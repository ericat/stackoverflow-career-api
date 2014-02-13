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
    expose :stack_url
    expose :tag_names
  end

  has n, :tags, :through => Resource
  has n, :benefits
  has n, :jobs

  property :id, Serial, :required => true
  property :name, Text, :required => true
  property :avatar, Text
  property :size, String
  property :status, Text
  property :founded, Integer
  property :url, Text
  property :company_id, Text
  property :created_at, Time
  property :scraping_round, Integer
  property :stack_url, Text


  def tag_names
    tags.map(&:name)
  end
end

