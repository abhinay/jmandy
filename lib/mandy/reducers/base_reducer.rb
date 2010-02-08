module Mandy
  module Reducers
    class Base < Mandy::Task
      
      def initialize(key, values, output)
        @key, @values, @output = key, values, output
      end

      def self.compile(opts={}, &blk)
        Class.new(Mandy::Reducers::Base) do 
          self.class_eval do
            define_method(:reducer, blk) if blk
          end
        end
      end
    
      def execute
        reducer(@key, @values)
      end
    
      private
      
      def reducer(key,values)
        #nil
      end
    end
  end
end