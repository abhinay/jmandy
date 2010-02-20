module JMandy
  module Reducers
    class PassThroughReducer < Base
      def reduce(key,values)
        values.each {|value| emit(key, value)}
      end
    end
  end
end
