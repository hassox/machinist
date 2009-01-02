module Machinist
  class AbstractAdapter
    # :api: private
    def self.inherited(klass)
      Machinist.add_adapter klass
    end
    
    # Use this to set the priority of your adapter
    # If you have a very specific test to see if this adapter should be used in
    # use_for_class? then the priority should be set at 1.0
    # but if it is ambigious, then it should be set low.  
    # A test for a plain ruby object will return true always for example, so
    # the priority should be set lower to give the other adapters a chance to match
    # :api: plugin
    def self.priority(num = nil)
      if num
        @priority = num.to_f
      else
        @priority ||= 0.0
      end
    end
    
    # Put code to save the object in here.  For PORO (plain old ruby objects) this
    # can just be blank
    # :api: overwritable
    def self.save(obj)
    end
    
    # A test to see if this adapter should be used for the specified class.
    # If the test is ambiguous, then it should be given a low priority
    # :api: overwritable
    def self.use_for_class?(obj)
      raise "Need to add a use_for_class? method in your #{self.class} adapter"
    end
  end
end