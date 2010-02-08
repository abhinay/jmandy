def setup(conf)
end

def map(key, value, output)
  Mandy::Job.find_by_name(job_name).run_map(key, value, output)
end

def reduce(key, values, output)
  Mandy::Job.find_by_name(job_name).run_reduce(key, values, output)
end
