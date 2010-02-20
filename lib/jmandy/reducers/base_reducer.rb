module JMandy
  module Reducers
    class Base < JMandy::Task
      
      def initialize(output)
        @output = output
      end

      def self.compile(opts={}, &blk)
        Class.new(JMandy::Reducers::Base) do 
          self.class_eval do
            define_method(:reduce, blk) if blk
            define_method(:setup, opts[:setup]) if opts[:setup]
            define_method(:teardown, opts[:teardown]) if opts[:teardown]
          end
        end
      end
      
      def reduce(key,values)
        #nil
      end
    end
  end
end