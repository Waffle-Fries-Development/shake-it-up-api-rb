class Group
  include DataMapper::Resource
  include DataMapper::Validations

  # Properties
  property :id,         Serial
  property :name,       String
  property :created_at, DateTime
  property :updated_at, DateTime

  has n, :users, :through => Resource

  # Validations
  validates_presence_of      :name

end
