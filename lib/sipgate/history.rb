module Sipgate
  class History
    
    ATTRIBUTES = [:id, :source, :target, :sourceAlias, :targetAlias, :type, :created, :lastModified, :direction, :status, :faxStatusType, :documentUrl, :reportUrl, :previewUrl].freeze
    
    attr_accessor *ATTRIBUTES
    
    def initialize(params)
      ATTRIBUTES.each do |att|
        send("#{att}=", params[att.to_s])
      end
    end
    
    def self.default_userid
      Sipgate.user_id || Sipgate::User.first_user_id
    end
    
    def self.all
      @histories ||= get_history
    end
    
    def self.find_by_id(entryid)
      get_history(entryid)
    end
    
    private
    
    def self.get_history(entryid=nil)
      response = Sipgate::Connexion.conn.get do |req|
        req.url "/v2/history/#{entryid}"
      end
      if response.status.eql?(200)
        body = JSON.parse(response.body)
        if body.has_key?('items')
          [].tap do |histories|
            body['items'].each do |item|
              histories << Sipgate::History.new(item)
            end
          end
        else
          Sipgate::History.new(body)
        end
      end
    end
  end
end