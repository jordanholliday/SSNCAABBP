class User < ActiveRecord::Base
  after_initialize :ensure_session_token
  before_save :downcase_email_remove_whitespace
  validates :email, :team_name, :password_digest, :session_token, presence: true
  validates :email, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}

  has_many :picks

  attr_reader :password

  def password=(password)
    @password = password.strip
    self.password_digest = BCrypt::Password.create(password).to_s
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password.strip)
  end

  def self.find_by_credentials(email, password)
    user = User.find_by(email: email.downcase.strip)
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

  def <=>(user)
    self_score = self.score
    user_score = user.score

    if self_score == user_score
      return [1, -1].sample
    else
      (self_score <=> user_score) * -1
    end
  end

  def limit
    score / 2
  end

  def score
    return 2000 unless TeamRoundResult.any?
    ActiveRecord::Base.connection.select_all( <<-SQL
        SELECT
          SUM(picks.points *
          picks.multiplier * (
            CASE teams.seed
            WHEN 1
            THEN 1.5
            ELSE teams.seed END
            )
          ) AS points
        FROM
          team_round_results
        JOIN
          picks ON
            picks.team_id = team_round_results.team_id AND
            picks.round_id = team_round_results.round_id
        JOIN
          teams ON
            teams.id = team_round_results.team_id
        WHERE
          team_round_results.win = true AND
          picks.user_id = #{id} AND
          picks.round_id IN (
            SELECT
              rounds.id
            FROM
              rounds
            WHERE
              rounds.picks_end < '#{DateTime.now + 12.hours}'
            ORDER BY
              rounds.picks_end DESC
            LIMIT
              2
            )
      SQL
      )
      .first["points"]
      .to_i
  end

  def self.scores_by_user_by_round
    return 2000 unless TeamRoundResult.any?

    ActiveRecord::Base.connection.select_all( <<-SQL
      SELECT
        users.team_name,
        users.name,
        picks.round_id,
        SUM(picks.points *
        picks.multiplier *
        teams.seed *
        (
        CASE WHEN
            team_round_results.win = true
        THEN
            1
        ELSE
            0
        END)
        ) AS points
      FROM
        team_round_results
      JOIN
        picks ON
          picks.team_id = team_round_results.team_id AND
          picks.round_id = team_round_results.round_id
      JOIN
        teams ON
          teams.id = team_round_results.team_id
      JOIN
        users ON users.id = picks.user_id
      GROUP BY
        users.team_name, users.name, picks.round_id
      SQL
      )
  end


  private
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end

  def downcase_email_remove_whitespace
    self.email = self.email.downcase.strip unless self.email.nil?
  end

end
