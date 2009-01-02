module Machinist
  class ActiveRecordAdapter < AbstractAdapter
    priority 0 # Least priority
    
    def self.use_for_class?(klass)
      true
    end
    
    def self.save(obj)
    end
  end
end