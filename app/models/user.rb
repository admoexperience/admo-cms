class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
   field :confirmation_token,   :type => String
   field :confirmed_at,         :type => Time
   field :confirmation_sent_at, :type => Time
   field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String


  #Custom actions.
  #We assign a user an account to which they have scoped control over units/info/content

  belongs_to :admo_account

  has_and_belongs_to_many :accounts, {class_name: 'AdmoAccount'}

  field :admin, :type => Boolean, :default => false
  field :first_name, :type => String, :default => ""
  field :last_name, :type => String, :default => ""

  before_save do |user|
    user.before_save_create_account
  end

  def before_save_create_account
    return unless self.admo_account.nil?

    account = AdmoAccount.new

    # avoid account name collisions
    if AdmoAccount.where(:name => self.company_name).count > 0
      self.company_name = "#{self.company_name} (#{self.first_name} #{self.last_name})"
    end

    account.name = self.company_name
    account.save!
    self.admo_account = account
    self.accounts << account
  end

  # used to temporarily store the company name on the user model when the user signs up with devise
  def company_name
    @company_name
  end

  # used to temporarily store the company name on the user model when the user signs up with devise
  def company_name=(name)
    @company_name = name
  end

  #Hack for now, we dont store name
  def email_to_name
    name = self.email[/[^@]+/]
    name.split(".").map {|n| n.capitalize }.join(" ")
  end

  def primary_account
    self.admo_account
  end
end
