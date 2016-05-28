class Brand
  include DataMapper::Resource
  include DataMapper::Validations

  # Properties
  property :id,           Serial
  property :name,         String
  property :display_name, String
  property :created_at,   DateTime
  property :updated_at,   DateTime

  has n, :flavors, :through => Resource

  # Validations
  validates_presence_of     :name
  validates_uniqueness_of   :name,    :case_sensitive => false

  def delete_flavors
    flavors.clear
    self
  end

  public
  def add_flavor(flavor)
    flavors << flavor
  end

end