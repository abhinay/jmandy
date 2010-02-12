module JMandy
  module Mappers
    class Base < JMandy::Task

      def initialize(key, value, output)
        @key, @value, @output = key, value, output
      end

      def self.compile(opts={}, &blk)
        Class.new(JMandy::Mappers::Base) do 
          self.class_eval do
            define_method(:mapper, blk) if blk
            define_method(:setup, opts[:setup]) if opts[:setup]
            define_method(:teardown, opts[:teardown]) if opts[:teardown]
          end
        end
      end
      
      def execute
        setup if self.respond_to?(:setup)
        mapper(@key, @value)
        teardown if self.respond_to?(:teardown)
      end
      
      private
      
      def mapper(key,value)
        #nil
      end
    end
  end
end