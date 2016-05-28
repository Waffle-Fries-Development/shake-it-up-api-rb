class User
  include DataMapper::Resource
  include DataMapper::Validations
  attr_accessor :password, :password_confirmation

  # Properties
  property :id,               Serial
  property :username,         String
  property :first_name,       String
  property :last_name,        String
  property :email,            String
  property :crypted_password, String, :length => 70
  property :created_at,       DateTime
  property :updated_at,       DateTime

  has n, :groups, :through => Resource

  # Validations
  validates_presence_of      :username
  validates_presence_of      :email
  validates_presence_of      :password,                          :if => :password_required
  validates_presence_of      :password_confirmation,             :if => :password_required
  validates_length_of        :password, :min => 4, :max => 40,   :if => :password_required
  validates_confirmation_of  :password,                          :if => :password_required
  validates_length_of        :username, :min => 3, :max => 100
  validates_uniqueness_of    :username, :case_sensitive => false
  validates_length_of        :email,    :min => 3, :max => 100
  validates_uniqueness_of    :email,    :case_sensitive => false
  validates_format_of        :email,    :with => :email_address

  # Callbacks
  before :valid?, :check_create_username
  before :save, :encrypt_password

  ##
  # This method is for authentication purpose.
  #
  def self.authenticate(username, password)
    user = first(:conditions => ['lower(username) = lower(?)', username]) if username.present?
    user && user.has_password?(password) ? user : nil
  end

  ##
  # This method is used by AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private

  def password_required
    crypted_password.blank? || password.present?
  end

  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(password) if password.present?
  end

  def check_create_username
    self.username = self.email if self.username.nil?
  end

  public
  def generate_auth_token
    payload = { user_id: self.id }
    AuthToken.encode(payload)
  end

  public
  def add_group(group)
    groups << group
  end

  public
  def has_group(group_name)
    !groups.first(:name => group_name).nil?
  end

  public
  def get_fullname
    "#{:first_mame} #{:last_name}"
  end

end
