require 'extlib'
require 'faker'
require 'sham'
 
module Machinist
  def self.with_save_nerfed
    begin
      @@nerfed = true
      yield
    ensure
      @@nerfed = false
    end
  end
  
  @@nerfed = false
  def self.nerfed?
    @@nerfed
  end
  
  module Extensions
    
    module ClassMethods
      def blueprint(&blueprint)
        @blueprint = blueprint
      end
  
      def make(attributes = {})
        raise "No blueprint for class #{self}" if @blueprint.nil?
        lathe = Lathe.new(self.new, attributes)
        lathe.instance_eval(&@blueprint)
        unless Machinist.nerfed?
          lathe.object.save!  if lathe.object.respond_to?(:save!)
          lathe.object.reload if lathe.object.respond_to?(:reload)
        end
        lo = lathe.object
        yield lo if block_given?
        lo
      end
    
      def make_unsaved(attributes = {})
        obj = Machinist.with_save_nerfed { make(attributes) }
        yield obj if block_given?
        obj
      end
    end
  end
  
  class Lathe
    def initialize(object, attributes)
      @object = object
      @assigned_attributes = []
      attributes.each do |key, value|
        @object.send("#{key}=", value)
        @assigned_attributes << key
      end
    end

    attr_reader :object

    def method_missing(symbol, *args, &block)
      if @assigned_attributes.include?(symbol)
        @object.send(symbol)
      else
        value = if block
          block.call
        elsif args.first.instance_of?(Hash) || args.empty?
          Object.full_const_get(symbol.to_s.camel_case).make(args.first || {})
        else
          args.first
        end
        @object.send("#{symbol}=", value)
        @assigned_attributes << symbol
      end
    end
  end
end

# Auto extend base ORM's if they are present
ActiveRecord::Base.extend(Machinist::Extensions::ClassMethods) if defined?(ActiveRecord)
DataMapper::Model.append_extensions(Machinist::Extensions::ClassMethods) if defined?(DataMapper)
