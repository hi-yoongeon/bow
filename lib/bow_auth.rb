require 'twitter_oauth'
require 'facebook_oauth'

module Bow
  module Auth
    class Twitter

      attr_accessor :redirect_url

      CONSUMER_KEY = "dX2ETek44FXOmLYexqJ1xA"
      CONSUMER_SECRET = "PM0mLkZyieTTW6SiknR26T59o9Icd0caprB2U7TU"
      CALLBACK_URL = "http://snsrc.daum.net:3000/signin/twitter/callback?redirect_url="

      attr_reader :client

      def initialize access_token="", access_secret=""
        client_factory access_token, access_secret
      end

      public
      def authorize_url
        @request_token = @client.request_token(
                                         :oauth_callback => CALLBACK_URL + redirect_url
                                         )
        @request_token.authorize_url
      end

      def access_token oauth_verifier
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

    class Facebook
      APPLICATION_ID = "372779472820178"
      APPLICATION_SECRET = "2c3fe5a80db0daf3345d1ba9be1c0aa2"
      CALLBACK_URL = "http://snsrc.daum.net:3000/signin/facebook/callback"
      
      attr_accessor :redirect_url
      attr_reader :client

      def initialize code = ""
        client_factory code
      end


      def authorize_url
        @client.authorize_url
      end

      def access_token code

        p code

        @client.authorize :code => code
      end

      private
      def client_factory code
        option = {
          :application_id => APPLICATION_ID,
          :application_secret => APPLICATION_SECRET,
          :callback => CALLBACK_URL
        }

        # option[:callback] = option[:callback] + args[:redirect_url] unless args[:redirect_url].nil?
        option[:code] = code unless code.empty?
        @client = FacebookOAuth::Client.new( option )
      end


    end

  end
end
