module Sipgate
  module Configuration
    
    mattr_writer :username, :password, :faxline_id, :user_id, :fax_filename
    
    def configure
      yield self
    end
    
    def username
      @@username ||= 'SET ME IN config/initializers/sipgate.rb'
    end
    
    def password
      @@password ||= 'SET ME IN config/initializers/sipgate.rb'
    end
    
    def faxline_id
      @@faxline_id
    end
    
    def user_id
      @@user_id
    end
    
    def fax_filename
      @@fax_filename ||= "FAX"
    end
    
  end
end
