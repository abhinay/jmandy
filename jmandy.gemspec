Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.homepage = "http://github.com/abhinay/mandy"

  s.name = 'jmandy'
  s.version = File.read(File.join(File.dirname(__FILE__),'VERSION'))
  s.date = '2009-10-19'

  s.description = "JMandy is Ruby Map/Reduce Framework built onto of the Hadoop Distributed computing platform."
  s.summary     = "Map/Reduce Framework"

  s.authors = ["Andy Kent", "Paul Ingles", "Abhinay Mehta"]
  s.email = "andy.kent@me.com"
  
  s.executables = %w[
    jmandy-hadoop
  ]

  # = MANIFEST =
  s.files = %w[
    bin/jmandy-hadoop
    VERSION
    Rakefile
    bootstrap.rb
    geminstaller.yml
    lib/jmandy.rb
    lib/jmandy/errors.rb
    lib/jmandy/support/tuple.rb
    lib/jmandy/support/array_serializer.rb
    lib/jmandy/task.rb
    lib/jmandy/job.rb
    lib/jmandy/packer.rb
    lib/jmandy/mappers/base_mapper.rb
    lib/jmandy/mappers/transpose_mapper.rb
    lib/jmandy/mappers/pass_through_mapper.rb
    lib/jmandy/reducers/base_reducer.rb
    lib/jmandy/reducers/transpose_reducer.rb
    lib/jmandy/reducers/pass_through_reducer.rb
    lib/jmandy/reducers/sum_reducer.rb
    lib/jmandy/reducers/max_reducer.rb
    lib/jmandy/reducers/min_reducer.rb
  ]
  # = MANIFEST =
  
  s.has_rdoc = false
  s.require_paths = %w[lib]
end
