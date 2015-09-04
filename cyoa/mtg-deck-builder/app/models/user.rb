class User < ActiveRecord::Base
  has_many :decks, dependent: :destroy
  has_secure_password

  VALID_EMAIL_REGEX = /.+@.+\..+/i

  validates :username, presence: true,
                       uniqueness: true,
                       length: { maximum: 50 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true,
                       confirmation: true,
                       length: { minimum: 6, maximum: 255 },
                       allow_nil: true
end
