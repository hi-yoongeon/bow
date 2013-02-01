class User < ActiveRecord::Base
  has_one :twitter_user_info
  has_one :facebook_user_info

  attr_accessible :email, :screen_name

  @authorized = false


  def auth_twitter=(twitter)
    @auth_twitter = twitter
  end
  def auth_twitter
    @auth_twitter
  end


  def authorized?
    @authorized
  end

end
