module Sipgate
  class Authentication
    
    class AuthenticationError < StandardError; end
    
    include Singleton
    
    attr_reader :token, :payload
    
    
    def token
      set_token if payload.nil? || expired?
      @token
    end
    
    def self.token
      self.instance.token
    end
    
    private
    
    def username
      Rails.logger.error "\e[31m[SWITCHY] Username not set. Check initializer\033[0m" if Sipgate.username.blank?
      Sipgate.username
    end
    
    def password
      Rails.logger.error "\e[31m[SWITCHY] Password not set. Check initializer\033[0m" if Sipgate.password.blank?
      Sipgate.password
    end
    
    
    def response
      @response ||= Sipgate::Connexion.conn(authenticated: false).post do |req|
        req.url '/v1/authorization/token'
        req.headers['Content-Type'] = 'application/json'
        req.body = {username: username, password: password}.to_json
      end
    end
    
    def set_token
      raise AuthenticationError unless response.status.eql?(200)
      @token = JSON.parse(response.body)['token']
      @payload = JSON.parse(Base64.decode64(@token.split('.').second)).symbolize_keys!
    end
    
    def expired?
      payload[:exp] < Time.now.to_i
    end

    
  end
  
end