class Job

  include DataMapper::Resource
  include Grape::Entity::DSL

  entity do
    expose :job_id
    expose :title
    expose :description
    expose :url
    expose :jscore
    expose :location
    expose :company_name
    expose :tag_names
  end

  has n, :tags, :through => Resource
  belongs_to :company, required: false

  property :id, Serial
  property :job_id, String, :required => true
  property :title, Text, :required => true
  property :description, Text
  property :url, Text
  property :jscore, Integer
  property :location, Text
  property :company_name, Text
  property :scraping_round, Integer
  property :created_at, Time

  def tag_names
    tags.map(&:name)
  end

end