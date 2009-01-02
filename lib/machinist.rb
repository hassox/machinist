require 'active_support'
require 'sham'
require File.join(File.dirname(__FILE__), "machinist", "adapters", "abstract")
 
module Machinist
  # :api: private
  def self.adapters
    @adapters ||= []
    @_adapter_size ||= @adapters.size
    unless @adapters.size == @_adapter_size
      @adapters = @adapters.uniq.sort_by{|a| a.priority}.reverse
      @_adapter_size = @adapters.size
    end
    @adapters
  end
  
  # :api: private
  def self.add_adapter(adapter)
    adapters << adapter
  end
  
  # :api: private
  def self.adapter_for(klass)
    adapters.detect{|a| a.use_for_class?(klass)} || raise("No Adapter found for #{klass}")
  end
  
  module Extensions
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def blueprint(&blueprint)
        @blueprint = blueprint
        @machinist_adapter = Machinist.adapter_for(self)
      end
  
      def make(attributes = {}, &block)
        obj = make_unsaved(attributes.merge(:_save_ => true), &block)
        @machinist_adapter.save(obj)
      end
    
      def make_unsaved(attributes = {})
        raise "No blueprint for class #{self}" if @blueprint.nil?
        lathe = Lathe.new(self, attributes)
        lathe.instance_eval(&@blueprint)
        returning(lathe.object) do |object|
          yield object if block_given?
        end
      end
    end
  end
  
  class Lathe
    def initialize(klass, attributes = {})
      @save = !!attributes.delete(:_save_)
      @object = klass.new
      attributes.each {|key, value| @object.send("#{key}=", value) }
      @assigned_attributes = attributes.keys.map(&:to_sym)
    end

    # Undef a couple of methods that are common ActiveRecord attributes.
    # (Both of these are deprecated in Ruby 1.8 anyway.)
    undef_method :id
    undef_method :type
    
    attr_reader :object

    def method_missing(symbol, *args, &block)
      if @assigned_attributes.include?(symbol)
        @object.send(symbol)
      else
        value = if block
          block.call
        elsif args.first.is_a?(Hash) || args.empty?
          meth = @save ? :make : :make_unsaved
          symbol.to_s.camelize.constantize.send(meth, (args.first || {}))
        else
          args.first
        end
        @object.send("#{symbol}=", value)
        @assigned_attributes << symbol
      end
    end
  end
end

require File.join(File.dirname(__FILE__), 'machinist/adapters/active_record') if defined?(ActiveRecord)