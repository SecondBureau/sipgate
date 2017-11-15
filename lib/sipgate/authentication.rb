module Sipgate
  class Authentication
    
    class AuthenticationError < StandardError; end
    
    include Singleton
    
    attr_reader :token
    
    def initialize
      set_token
    end
    
    private
    
    def username
      Rails.logger.error "\e[31m[SWITCHY] Username not set. Check initializer\033[0m" if Sipgate::Configuration.username.blank?
      Sipgate::Configuration.username
    end
    
    def password
      Rails.logger.error "\e[31m[SWITCHY] Password not set. Check initializer\033[0m" if Sipgate::Configuration.password.blank?
      Sipgate::Configuration.password
    end
    
    
    def response
      @response ||= Sipgate::Connexion.conn(authenticated: false).post do |req|
        req.url '/authorization/token'
        req.headers['Content-Type'] = 'application/json'
        req.body = {username: username, password: password}.to_json
      end
    end
    
    def set_token
      raise AuthenticationError unless response.status.eql?(200)
      @token = response.body
    end

    
  end
  
end