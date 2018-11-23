require 'ctpl/merger'

module Ctpl
  class Generate < Thor
    include Thor::Actions
    class_option :verbose, :type => :boolean, :aliases => '-v', :default => false, :banner => 'Activate verbose mode', :desc => 'If used show errors, stacktraces and more'

    desc 'generate', 'Handle all marked instances, either to install or install'
    method_option :basefolder, :aliases => 'b', :required => false, :type => :string, :default => './', :desc => "Optional - defaults to ./pipeline, falls back to PWD. The base-folder the pipeline.yaml, alias.yaml and the partials are located. \nIf you pass /tmp/foo we will look for /tmp/foo/pipeline.yaml, optionally for /tmp/foo/aliases.yaml and all /tmp/foo/*_.yaml files as partials"
    method_option :output, :aliases => 'o', :required => false, :type => :string, :default => './pipeline.yml', :desc => "Optional, defaults to pipeline.yml. Output path to save the merged yaml in"
    def generate
      baseFolder = options[:basefolder]
      merger = PipelineMerger.new("#{baseFolder}/pipeline.yaml", "#{baseFolder}/aliases.yaml", baseFolder)
      p = merger.merge
      say_status 'ok', "Transforming back to yaml ", :white
      yaml = p.to_yaml
      say_status 'ok', "Saving to #{options[:output]} ", :white
      File.write(options[:output], yaml)
    end
  end
end
