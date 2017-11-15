module Sipgate
  class Connexion
    include Singleton
    
    ROOT_URL = 'https://api.sipgate.com/v1/'
    
    def conn(options)
      options.delete(:authenticated){false} ? auth_connexion : connexion
    end
    
    private
    
    def connexion
      @connexion ||= get_connexion(false)
    end
    
    def auth_connexion
      @auth_connexion ||= get_connexion(true)
    end
    
    def get_connexion(authenticated)
      Faraday.new(url: ROOT_URL) do |faraday|
        faraday.response :logger do | logger |
          logger.filter(/(api_key=)(\w+)/,'\1[REMOVED]')
        end
        faraday.authorization(:Bearer, Sipgate::Authentication.token)
      end
    end
    
  end
  
end