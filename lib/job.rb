class Job

  include DataMapper::Resource

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


end