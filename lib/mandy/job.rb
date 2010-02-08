module Mandy
  class Job

    class << self
      def jobs
        @jobs ||= []
      end
      
      def find_by_name(name)
        jobs.find {|job| job.name == name }
      end
    end
    
    attr_reader :settings
    attr_reader :name
    attr_reader :input_format_options

    def initialize(name, &blk)
      @name = name
      @settings = {}
      @map, @reduce = nil, nil
      set('mapred.job.name', name)
      instance_eval(&blk) if blk
      auto_set_reduce_count
    end
    
    def set(key, value)
      @settings[key.to_s] = value.to_s
    end
    
    def map_tasks(count)
      set('mapred.map.tasks', count)
    end
    
    def reduce_tasks(count)
      set('mapred.reduce.tasks', count)
    end
    
    def setup(&blk)
      @setup = blk
    end
    
    def teardown(&blk)
      @teardown = blk
    end
    
    def map(klass=nil, &blk)
      @map = klass || blk
    end
    
    def reduce(klass=nil, &blk)
      @reduce = klass || blk
    end
    
    def run_map(key, value, output, &blk)
      mapper = mapper_class.new(key, value, output)
      yield(mapper) if blk
      mapper.execute
    end
    
    def run_reduce(key, values, output, &blk)
      reducer = reducer_class.new(key, values, output)
      yield(reducer) if blk
      reducer.execute
    end
    
    def reducer_defined?
      !@reduce.nil?
    end
    
    private
    
    def auto_set_reduce_count
      return if settings.has_key?('mapred.reduce.tasks')
      reduce_tasks(reducer_defined? ? 1 : 0)
    end

    def mapper_class
      return Mandy::Mappers::PassThroughMapper unless @map
      @mapper_class ||= compile_map
    end
    
    def reducer_class
      return Mandy::Reducers::PassThroughReducer unless @reduce
      @reducer_class ||= compile_reduce
    end
    
    def compile_map
      @map.is_a?(Proc) ? Mandy::Mappers::Base.compile({}, &@map) : @map
    end
    
    def compile_reduce
      @reduce.is_a?(Proc) ? Mandy::Reducers::Base.compile({}, &@reduce) : @reduce
    end
  end
end