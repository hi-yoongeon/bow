module Bow

  class SNSManager

    # SNSManager.send :services => [<OAuth>,..], :message => "Message"
    def self.send params
      services = params[:services]
      message = params[:message]
      services.each do |service|
        service.send message
      end
    end
end
