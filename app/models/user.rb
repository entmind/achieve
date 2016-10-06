class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # :omniauthableを追加したよ。dive14
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable
  # dive15で追記したよ。「dependent: :destroy」は、Blogモデルが削除されたら紐づくコメントも削除する。
  has_many :blogs, dependent: :destroy
  # dive15で追記したよ。コメント機能
  has_many :comments, dependent: :destroy
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
  
  # dive14で追記したよ。omniauthでサインアップしたアカウントのユーザ情報の変更出来るようにする。
  def update_with_password(params, *options)
    if provider.blank?
      super
    else
      params.delete :current_password
      update_without_password(params, *options)
    end
  end
  
end
