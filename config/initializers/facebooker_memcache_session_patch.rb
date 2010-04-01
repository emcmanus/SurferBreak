class Session
  class MemCacheStore
    def check_id(id) #:nodoc:#
      /[^0-9a-zA-Z\-\._]+/ =~ id.to_s ? false : true
    end
  end
end