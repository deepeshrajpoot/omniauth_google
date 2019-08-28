class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable, :omniauthable, 
  :omniauth_providers => [:google_oauth2]

   def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      nickname = auth.info.name if auth.provider == 'google_oauth2'

      user = User.create(
        uid:      auth.uid,
        provider: auth.provider,
        nickname: nickname,
        email:    User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end
end