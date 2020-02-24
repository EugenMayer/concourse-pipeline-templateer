Gem::Specification.new do |s|
  s.name        = 'ctpl'
  s.version     = File.read('VERSION')
  s.summary     = 'Implements an opinionated tool to template / split concourse pipeline files into easier smaller structural parts'
  s.description = 'This tool enables you to split your pipeline.yml into several single files, as many as you like and generates a fly compatible pipeline.yml while merging jobs/resource_types/resources/groups'
  s.authors     = ['Eugen Mayer']
  s.executables = %w[ctpl]
  s.email       = 'eugen.mayer@kontextwork.de'
  s.files       = Dir['lib/**/*.rb','thor/**/*.thor','Thorfile', 'bin/ctpl*','VERSION']
  s.license     = 'GPL'
  s.homepage    = 'https://github.com/EugenMayer/concourse-pipeline-templateer'
  s.add_runtime_dependency 'thor', '~> 1.0', '>= 1.0.0'
end
