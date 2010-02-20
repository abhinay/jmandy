require 'uri'

def setup(conf)
  args = conf.get("mapred.args").split(",")
  script = args[2]
  job_name = URI.unescape(args[3])
  conf.set("mandy.job.script", script)
  conf.set("mandy.job.name", job_name)

  require script
  job = JMandy::Job.find_by_name(job_name)
  job.settings.each { |key, value| conf.set(key,value) }

  return nil
end

def map(key, value, context)
  unless @mapper
    require context.get_conf.get("mandy.job.script")
    job_name = context.get_conf.get("mandy.job.name")
    @mapper = JMandy::Job.find_by_name(job_name).mapper(context)
    @mapper.setup if @mapper.respond_to?(:setup)
  end
  
  @mapper.map(key,value)
end

def reduce(key, values, context)
  unless @reducer
    require context.get_conf.get("mandy.job.script")
    job_name = context.get_conf.get("mandy.job.name")
    @reducer = JMandy::Job.find_by_name(job_name).reducer(context)
    @reducer.setup if @reducer.respond_to?(:setup)
  end
  
  @reducer.reduce(key,values)
end
