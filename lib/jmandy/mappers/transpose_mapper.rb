module JMandy
  module Mappers
    class TransposeMapper < Base
      def map(key,value)
        # default map is simply a pass-through
        emit(value, key)
      end
    end
  end
end