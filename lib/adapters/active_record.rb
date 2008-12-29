require 'active_record'

module Machinist
  class ActiveRecordAdapter < AbstractAdapter
    priority 0.5 # Medium Priority
    def self.use_for_class?(klass)
      klass.ancestors.include?(ActiveRecord::Base)
    end
    
    def self.save(obj)
      obj.save!
      obj.reload
      obj
    end
  end
end

class ActiveRecord::Base
  include Machinist::Extensions
end