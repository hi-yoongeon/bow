require 'twitter_oauth'
require 'facebook_oauth'

module Bow
  module Auth
    class Twitter
      CONSUMER_KEY = "dX2ETek44FXOmLYexqJ1xA"
      CONSUMER_SECRET = "PM0mLkZyieTTW6SiknR26T59o9Icd0caprB2U7TU"
      CALLBACK_URL = "http://seoho.me:3000/signin/twitter/callback"

      attr_reader :client

      def initialize token = "", secret = ""
        client_factory token, secret
      end

      public
      def authorize_url
        @request_token = @client.request_token(
                                         :oauth_callback => CALLBACK_URL
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

      def send message
        tweet message
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
      CALLBACK_URL = "http://seoho.me:3000/signin/facebook/callback"

      attr_reader :client

      def initialize token = ""
        client_factory token
      end


      def authorize_url
        @client.authorize_url
      end

      def access_token code
        @client.authorize :code => code
      end

      def send message
        @client.me.feed(:create, :message => message)
      end

      private
      def client_factory token
        option = {
          :application_id => APPLICATION_ID,
          :application_secret => APPLICATION_SECRET,
          :callback => CALLBACK_URL
        }

        option[:token] = token unless token.empty?
        @client = FacebookOAuth::Client.new( option )
      end


    end

  end
end
