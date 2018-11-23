Gem::Specification.new do |s|
  s.name        = 'ctpl'
  s.version     = File.read('VERSION')
  s.summary     = 'ctpl'
  s.description = 'ctpl'
  s.authors     = ['Eugen Mayer']
  s.executables = %w[ctpl]
  s.email       = 'eugen.mayer@kontextwork.de'
  s.files       = Dir['lib/**/*.rb','thor/**/*.thor','Thorfile', 'bin/ctpl*','VERSION']
  s.license     = 'GPL'
  s.homepage    = ''
  s.add_runtime_dependency 'thor', '~> 0.20', '>= 0.20.0'
end