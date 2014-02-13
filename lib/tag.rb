class Tag

  include DataMapper::Resource
 
  has n, :jobs, :through => Resource
  has n, :companies, :through => Resource

  property :id, Serial
  property :name, Text

end