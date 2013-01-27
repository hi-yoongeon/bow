require 'twitter_oauth'

module Bow
  class Twitter

    CONSUMER_KEY = "dX2ETek44FXOmLYexqJ1xA"
    CONSUMER_SECRET = "PM0mLkZyieTTW6SiknR26T59o9Icd0caprB2U7TU"
    CALLBACK_URL = "http://snsrc.daum.net:3000/login/twitter/callback"

    attr_reader :client

    def initialize access_token="", access_secret=""
      client_factory access_token, access_secret
    end

    public
    def get_authorize_url
      @request_token = @client.request_token(
                                         :oauth_callback => CALLBACK_URL
                                            )
      @request_token.authorize_url
    end

    def get_access_token oauth_verifier
      @access_token = @client.authorize(
                        @request_token.token,
                        @request_token.secret,
                        :oauth_verifier => oauth_verifier
                        )
      # client_factory @access_token.token, @access_token.secret
      @access_token
    end

    def tweet status
      @client.update status
    end

    private
    def client_factory token = "", secret = ""
      args = {
        :consumer_key => CONSUMER_KEY,
        :consumer_secret => CONSUMER_SECRET
      }

      args[:token] = token unless token.empty?
      args[:secret] = secret unless secret.empty?
      @client = TwitterOAuth::Client.new( args )
    end
  end
end
