module JMandy
  module Reducers
    class Base < JMandy::Task
      
      def initialize(key, values, output)
        @key, @values, @output = key, values, output
      end

      def self.compile(opts={}, &blk)
        Class.new(JMandy::Reducers::Base) do 
          self.class_eval do
            define_method(:reducer, blk) if blk
            define_method(:setup, opts[:setup]) if opts[:setup]
            define_method(:teardown, opts[:teardown]) if opts[:teardown]
          end
        end
      end
      
      def execute
        setup if self.respond_to?(:setup)
        reducer(@key, @values)
        teardown if self.respond_to?(:teardown)
      end
      
      private
      
      def reducer(key,values)
        #nil
      end
    end
  end
end