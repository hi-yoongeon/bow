class FacebookUserInfo < ActiveRecord::Base
  belongs_to :user

  def self.find_by_token token
    FacebookUserInfo.where :token => token
  end

  # def self.add_facebook_info params
  #   token = params[:token]
  #   facebook_info = params[:facebook_info]
  #   user_id = nil

  #   transaction do
  #     user = User.new
  #     user.save

  #     user_id = user.id

  #     facebook_user_info = FacebookUserInfo.new
  #     facebook_user_info.token = token
  #     facebook_user_info.facebook_id = facebook_info["id"]
  #     facebook_user_info.screen_name = facebook_info["username"]
  #     facebook_user_info.user_id = user.id

  #     facebook_user_info.save
  #   end

  #   user_id
  # end
end
