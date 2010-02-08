module Mandy
  module Mappers
    class Base < Mandy::Task

      def initialize(key, value, output)
        @key, @value, @output = key, value, output
      end

      def self.compile(opts={}, &blk)
        Class.new(Mandy::Mappers::Base) do 
          self.class_eval do
            define_method(:mapper, blk) if blk
          end
        end
      end
      
      def execute
        mapper(@key, @value)
      end

      private
    
      def mapper(key,value)
        #nil
      end
    end
  end
end
