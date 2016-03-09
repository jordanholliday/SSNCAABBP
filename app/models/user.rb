class User < ActiveRecord::Base
  after_initialize :ensure_session_token
  before_save :downcase_email
  validates :email, :team_name, :password_digest, :session_token, presence: true
  validates :email, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  has_many :picks

  attr_reader :password

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email.downcase)
    return nil unless user

    if user.is_password?(password)
      user
    else
      nil
    end
  end

  def reset_session_token
    self.session_token = SecureRandom.urlsafe_base64
    save!
  end

  def score
    return 1000 if Round.where("picks_end < ?", DateTime.now).empty?
    1000
    # come back to total up pick results
  end

  def <=>(user)
    self.score <=> user.score
  end

  def limit
    score / 2
  end

  private
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def downcase_email
    self.email = self.email.downcase unless self.email.nil?
  end
end
