module Sipgate
  class Fax
    
    def self.send(fax_number, pdf)
      rand(1..1000)
    end
    
    def self.status(fax_id)
      %w[success failed working].sample.to_sym
    end
    
  end
end