module Machinist
  class DataMapperAdapter < AbstractAdapter
    priority 0.5 # Medium Priority
    def self.use_for_class?(klass)
      !!(DataMapper::Resource > klass)
    end
    
    def self.save(obj)
      obj.save
      obj.reload
      obj
    end
  end
end

DataMapper::Model.append_extensions(Machinist::Extensions::ClassMethods)