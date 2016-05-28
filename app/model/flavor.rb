class Flavor
  include DataMapper::Resource
  include DataMapper::Validations

  # Properties
  property :id,           Serial
  property :name,         String
  property :display_name, String
  property :created_at,   DateTime
  property :updated_at,   DateTime

  has n, :brands, :through => Resource

  # Validations
  validates_presence_of  :name

  public
  def add_brand(brand)
    brands << brand
  end

end