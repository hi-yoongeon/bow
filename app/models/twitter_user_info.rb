class TwitterUserInfo < ActiveRecord::Base
  attr_accessible  :user_id, :token, :secret, :twitter_id, :screen_name, :profile_image_url

  def self.find_by_access_token access_token
    # p access_token
    TwitterUserInfo.where :token => access_token.token, :secret => access_token.secret
  end

  def self.add_twitter_info params

    client = params[:client]
    access_token = params[:access_token]
    twitter_info = client.info
    user_id = nil

    transaction do
      user = User.new
      user.save

      user_id = user.id

      twitter_user_info = TwitterUserInfo.new
      twitter_user_info.token = access_token.token
      twitter_user_info.secret = access_token.secret
      twitter_user_info.twitter_id = twitter_info['id']
      twitter_user_info.screen_name = twitter_info['screen_name']
      twitter_user_info.profile_image_url = twitter_info['profile_image_url']
      twitter_user_info.user_id = user.id

      twitter_user_info.save
    end

    p "user_id => #{user_id}"

    user_id
  end

end
