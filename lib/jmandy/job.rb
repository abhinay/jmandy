module JMandy
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
      reduce_tasks(1) unless @settings.has_key?('mapred.reduce.tasks')
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
    
    def mapper(output)
      return JMandy::Mappers::PassThroughMapper.new(output) unless @map
      compile_map.new(output)
    end
    
    def reducer(output)
      return JMandy::Reducers::PassThroughReducer.new(output) unless @reduce
      compile_reduce.new(output)
    end
    
    def reducer_defined?
      !@reduce.nil?
    end
    
    private
    
    def compile_map
      args = {}
      args[:setup] = @setup if @setup
      args[:teardown] = @teardown if @teardown
      @map.is_a?(Proc) ? JMandy::Mappers::Base.compile(args, &@map) : @map
    end
    
    def compile_reduce
      args = {}
      args[:setup] = @setup if @setup
      args[:teardown] = @teardown if @teardown
      @reduce.is_a?(Proc) ? JMandy::Reducers::Base.compile(args, &@reduce) : @reduce
    end
  end
end