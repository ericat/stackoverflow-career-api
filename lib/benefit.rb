class Benefit

  include DataMapper::Resource

  property :id, Serial
  property :name, Text

	belongs_to :company, required: true

end