require 'twitter'

class TwitterController < ApplicationController
  def tweet    
    twt = Bow::Twitter.new params[:access_token], params[:access_secret]
    twt.tweet params[:tweet]
  end  
end
