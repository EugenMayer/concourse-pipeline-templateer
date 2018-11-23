main = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
main = File.dirname(main)
lib = File.expand_path('./lib', main)
thor = File.expand_path('./thor', main)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
$dwm_root = File.expand_path('./', __dir__)


require 'ctpl/parser/pipeline'

Dir.glob(File.join(thor, '/**/*.thor')).each { |taskfile|
  # noinspection RubyResolve
  load taskfile
}
