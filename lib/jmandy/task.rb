module JMandy
  class Task
    KEY_VALUE_SEPERATOR = "\t" unless defined?(KEY_VALUE_SEPERATOR)
    NUMERIC_PADDING = 16
    
    def output=(output)
      @output = output
    end

    def emit(key, value="")
      @output.collect serialize_key(key), serialize_value(value)
    end
    
    private
    
    def pad(key)
      key_parts = key.to_s.split(".")
      key_parts[0] = key_parts.first.rjust(NUMERIC_PADDING, '0')
      key_parts.join('.')
    end
    
    def serialize_key(key)
      key = pad(key) if key.is_a?(Numeric) && key.to_s.length < NUMERIC_PADDING
      key.to_s
    end

    def serialize_value(value)
      value = ArraySerializer.new(value) if value.is_a?(Array)
      value.to_s
    end
  end
end