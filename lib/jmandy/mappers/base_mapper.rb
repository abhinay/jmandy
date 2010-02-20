module JMandy
  module Mappers
    class Base < JMandy::Task

      def initialize(output)
        @output = output
      end
      
      def self.compile(opts={}, &blk)
        Class.new(JMandy::Mappers::Base) do 
          self.class_eval do
            define_method(:map, blk) if blk
            define_method(:setup, opts[:setup]) if opts[:setup]
            define_method(:teardown, opts[:teardown]) if opts[:teardown]
          end
        end
      end
      
      def map(key,value)
        #nil
      end
    end
  end
end