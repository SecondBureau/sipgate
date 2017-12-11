require 'faraday'

module Sipgate
  class Connexion
    include Singleton
    
    ROOT_URL = 'https://api.sipgate.com/'
    
    def self.conn(options={})
      options.delete(:authenticated){true} ? auth_connexion : connexion
    end
    
    private
    
    def self.connexion
      @connexion ||= get_connexion(false)
    end
    
    def self.auth_connexion
      get_connexion(true)
    end
    
    def self.get_connexion(authenticated)
      Faraday.new(url: ROOT_URL) do |conn|
        conn.request  :url_encoded
        conn.response :logger do |logger|
          logger.filter(/(api_key=)(\w+)/,'\1[REMOVED]')
        end
        conn.authorization(:Bearer, Sipgate::Authentication.token) if authenticated
        conn.adapter  Faraday.default_adapter
     end
    end
  end
  
end