module Sipgate
  module Configuration
    
    mattr_writer :username, :password
    
    def configure
      yield self
    end
    
    def username
      @@username ||= 'SET ME IN config/initializers/sipgate.rb'
    end
    
    def password
      @@password ||= 'SET ME IN config/initializers/sipgate.rb'
    end
    
  end
end
