module Sipgate
  class Faxline
    
    class NoDefaultFaxlineFoundError < StandardError; end
    
    ATTRIBUTES = [:id, :alias, :tagline, :canSend, :canReceive].freeze
    
    attr_accessor *ATTRIBUTES
    
    def initialize(params)
      ATTRIBUTES.each do |att|
        send("#{att}=", params[att.to_s])
      end
    end

    def self.all
      @faxlines ||= get_faxlines
    end
    
    def self.first_faxline_id
      raise NoDefaultFaxlineFoundError if all.first.nil?
      all.first.id
    end
    
    def self.default_userid
      Sipgate.user_id || Sipgate::User.first_user_id
    end
    
    private
    
    def self.get_faxlines(userid = nil)
      userid ||= default_userid
      response = Sipgate::Connexion.conn.get do |req|
        req.url "/v2/#{userid}/faxlines"
      end
      if response.status.eql?(200)
        [].tap do |faxlines|
          JSON.parse(response.body)['items'].each do |item|
            faxlines << Sipgate::Faxline.new(item)
          end
        end
      end
    end
    
  end
end