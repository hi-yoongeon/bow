class MainController < ApplicationController

  def index
    p verify_authenticity_token

    # @twitter_info = current_user.twitter_user_info

    # p @twitter_info
  end

end
