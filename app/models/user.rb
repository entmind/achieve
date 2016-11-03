class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :omniauthableを追加したよ。dive14
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
  # dive15で追記したよ。コメント機能
  # 「dependent: :destroy」は、Blogモデルが削除されたら紐づくコメントも削除する。
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy
  # dive16で追加したよ。フォロー機能
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :followers, through: :reverse_relationships, source: :follower
  # dive17で追記したよ。タスク機能
  has_many :tasks, dependent: :destroy
  has_many :submit_requests, dependent: :destroy

  # carrierwave用用の設定設定。dive14で追記したよ。
  mount_uploader :avatar, AvatarUploader

  # dive14で追記したよ。
  def self.find_for_facebook_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    unless user
      user = User.new(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        image_url: auth.info.image,
        password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      user.save(validate: false)
    end
    user
  end

  # dive14で追記したよ。
  def self.find_for_twitter_oauth(auth, signed_in_resource = nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first

    unless user
      user = User.new(
        name: auth.info.nickname,
        image_url: auth.info.image,
        provider: auth.provider,
        uid: auth.uid,
        email: auth.info.email ||= "#{auth.uid}-#{auth.provider}@example.com",
        password: Devise.friendly_token[0, 20]
      )
      user.skip_confirmation!
      user.save
    end
    user
  end

  # dive14で追記したよ。
  def self.create_unique_string
    SecureRandom.uuid
  end
  
  # dive14で追記したよ。omniauthでサインアップしたアカウントのユーザ情報の変更出来るようにする。
  def update_with_password(params, *options)
    if provider.blank?
      super
    else
      params.delete :current_password
      update_without_password(params, *options)
    end
  end
  
  # dive16で追記したよ。
  # 指定のユーザーをフォローする
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end
  # フォローしているかどうかをかくにんする
  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)
  end
  #  指定のユーザーのフォローを解除する
  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end
  # dive18で追記したよ。「つながっているユーザを取得する」
  def friend
    followers & followed_users
  end
end
