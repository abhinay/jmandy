module JMandy
  module Reducers
    class MaxReducer < Base
      def reduce(key,values)
        values.map! {|value| value.to_f}
        emit(key, values.max)
      end
    end
  end
end
