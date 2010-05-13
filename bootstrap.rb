require 'uri'

def setup(job)
  conf = job.get_configuration
  args = conf.get("mapred.args").split(",")
  script = args[2]
  job_name = URI.unescape(args[3])

  conf.set("mandy.job.script", script)
  conf.set("mandy.job.name", job_name)
  conf.set("mandy.payload.name", args[4])
  
  require script
  mandy_job = JMandy::Job.find_by_name(job_name)
  mandy_job.settings.each { |key, value| conf.set(key,value) }
  
  job.set_output_key_class(Java::OrgApacheHadoopIo::Text);
	job.set_output_value_class(Java::OrgApacheHadoopIo::Text);
  
  return nil
end

def map(key, value, context)
  unless @mapper
    uncompress_payload(context.get_conf)
    job_name = context.get_conf.get("mandy.job.name")
    @mapper = JMandy::Job.find_by_name(job_name).mapper(context)
    @mapper.setup if @mapper.respond_to?(:setup)
  end
  
  key_value = value.split(JMandy::Task::KEY_VALUE_SEPERATOR)
  
  if key_value.size > 1
    k = key_value[0]
    v = key_value[1..-1].join(JMandy::Task::KEY_VALUE_SEPERATOR)
    @mapper.map(k,v)
  elsif key_value.size == 1
    @mapper.map(value)
  end
  
end

def reduce(key, values, context)
  unless @reducer
    uncompress_payload(context.get_conf)
    job_name = context.get_conf.get("mandy.job.name")
    @reducer = JMandy::Job.find_by_name(job_name).reducer(context)
    @reducer.setup if @reducer.respond_to?(:setup)
  end
  
  @reducer.reduce(key,values)
end

def uncompress_payload(conf)
  script = conf.get("mandy.job.script")
  payload = conf.get("mandy.payload.name")
  puts "Uncompressing #{payload}"
  `tar -xf #{payload}` if File.exists?(payload)
  require script
end
