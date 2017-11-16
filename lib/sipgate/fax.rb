module Sipgate
  class Fax
    
    class SipgateError < StandardError ; end
      

    
    attr_accessor :fax_number, :pdf, :faxline_id, :filename
    
    def initialize(params)
      @fax_number = params[:fax_number]
      @pdf        = params[:pdf]
      @faxline_id = params[:faxline_id]
      @filename   = params[:filename]
    end
    
    def self.send(fax_number, pdf)
      self.new(fax_number: fax_number, pdf: pdf).send
    end
    
    def faxline_id
      @faxline_id ||= (Sipgate.faxline_id || Sipgate::Faxline.first_faxline_id)
    end
    
    def filename
      @filename ||= Sipgate.fax_filename
    end
    
    def send
      response = Sipgate::Connexion.conn.post do |req|
        req.url '/v1/sessions/fax'
        req.headers['Content-Type'] = 'application/json'
        req.body = {  faxlineId: faxline_id, 
                      recipient: fax_number, 
                       filename: filename, 
                  base64Content: Base64.encode64(pdf)}.to_json
      end
      raise SipgateError, 'Sipgate returns HTTP 500' if response.status.eql?(500)
      raise Exception     unless response.status.eql?(200)
      JSON.parse(response.body)
    end
    
    def self.status(fax_id)
      %w[success failed working].sample.to_sym
      
     #https://api.sipgate.com/v1/userId/history/entryId
     
    end
    

    
  end
end