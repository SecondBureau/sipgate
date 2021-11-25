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
      Rails.logger.error "\e[31m[SIPGATE]\033[0m Username not set. Check initializer" if Sipgate.username.blank?
      Sipgate.username
    end
    
    def password
      Rails.logger.error "\e[31m[SIPGATE]\033[0m Password not set. Check initializer" if Sipgate.password.blank?
      Sipgate.password
    end
    
    
    def response
      @response ||= Sipgate::Connexion.conn(authenticated: false).post do |req|
        req.url '/v2/authorization/token'
        req.headers['Content-Type'] = 'application/json'
        req.body = {username: username, password: password}.to_json
      end
    end
    
    def set_token
      reset
      raise AuthenticationError unless response.status.eql?(200)
      @token    = JSON.parse(response.body)['token']
      @payload  = JSON.parse(Base64.decode64(@token.split('.').second)).symbolize_keys!
    end
    
    def expired?
      Rails.logger.debug "\e[35m[SIPGATE]\033[0m Expired? Payload[exp]: #{payload[:exp]}, Time.now: #{Time.now.to_i} "
      payload[:exp] < Time.now.to_i
    end
    
    def reset
      Rails.logger.info "\e[34m[SIPGATE]\033[0m Resetting"
      @token = nil
      @payload = nil
      @response = nil
    end

    
  end
  
end