require 'uri'

def setup(job)
  conf = job.get_configuration
  args = conf.get("mapred.args").split(",")
  script = args[2]
  job_name = URI.unescape(args[3])
  conf.set("mandy.job.script", script)
  conf.set("mandy.job.name", job_name)

  require script
  mandy_job = JMandy::Job.find_by_name(job_name)
  mandy_job.settings.each { |key, value| conf.set(key,value) }
  
  job.set_output_key_class(Java::OrgApacheHadoopIo::Text);
	job.set_output_value_class(Java::OrgApacheHadoopIo::Text);
  
  return nil
end

def map(key, value, context)
  unless @mapper
    require context.get_conf.get("mandy.job.script")
    job_name = context.get_conf.get("mandy.job.name")
    @mapper = JMandy::Job.find_by_name(job_name).mapper(context)
    @mapper.setup if @mapper.respond_to?(:setup)
  end
  
  key_value = value.split(JMandy::Task::KEY_VALUE_SEPERATOR)
  @mapper.map(*key_value) unless key_value.empty?
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
