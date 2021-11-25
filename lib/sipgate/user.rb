module Sipgate
  class User
    
    class NoDefaultUserFoundError < StandardError; end
    
    ATTRIBUTES = [:id, :firstname, :lastname, :email, :defaultDevice, :admin].freeze
    
    attr_accessor *ATTRIBUTES
    
    def initialize(params)
      ATTRIBUTES.each do |att|
        send("#{att}=", params[att.to_s])
      end
    end

    def self.all
      @users ||= get_users
    end
    
    def self.first_user_id
      raise NoDefaultUserFoundError if all.first.nil?
      @first_user_id ||= all.first.id
    end
    
    private
    
    def self.get_users
      response = Sipgate::Connexion.conn.get do |req|
        req.url '/v2/users'
      end
      if response.status.eql?(200)
        [].tap do |users|
          JSON.parse(response.body)['items'].each do |item|
            users << Sipgate::User.new(item)
          end
        end
      end
    end
    
  end
end