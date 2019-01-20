class User < ActiveRecord::Base
  has_many :replies, dependent: :destroy
  has_many :passages, dependent: :destroy
  
  # 关系表 by lh start!!!!!!!
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
                                   
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :following, through: :active_relationships, source: :followed
  # 关系表 by lh end!!!!!!!
  
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }



  # 闲置图片的大小
  validate  :picture_size

  # 添加图片上传
  mount_uploader :picture, PictureUploader



  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  # 关注另一个用户
  def follow(other_user)
    following << other_user
  end

  # 取消关注另一个用户
  def unfollow(other_user)
    following.delete(other_user)
  end

  # 如果当前用户关注了指定的用户，返回 true
  def following?(other_user)
    following.include?(other_user)
  end

  private

    # 验证上传的图片大小
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
end
