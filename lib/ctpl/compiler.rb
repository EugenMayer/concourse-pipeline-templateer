require 'yaml'

class PipelineCompiler
  include Thor::Shell

  def initialize(mainPipelinePath, globalAliasesPath, partialsFolder)
    loadGlobalAliases(globalAliasesPath)
    loadMainPipeline(mainPipelinePath)
    loadPartials(partialsFolder)
  end

  def merge
    pipeline = {}
    pipeline = parseToYaml(@mainPipeline) unless @mainPipeline == ""

    # that is our one level merger for the special keys we support
    @partials.each do |filename, partialContent|
      say_status 'ok', "merging partial #{filename}", :white
      partialAsHashmap = parseToYaml(partialContent)

      %w(jobs resources resource_types groups).each do |mergeKey|
        if partialAsHashmap.key?(mergeKey)
          pipeline[mergeKey] = [] unless pipeline.key?(mergeKey)
          pipeline[mergeKey].concat partialAsHashmap[mergeKey]
          partialAsHashmap.delete(mergeKey)
        end
      end

      # now put all the others which should not be conflicting. We might do this manually per key to inform
      # when we have conflicts .. since this will override existing keys
      pipeline.merge(partialAsHashmap)
    end

    raise "The pipeline-file is empty, most probably your baseFolder was wrong or it is empty" if pipeline.empty?
    pipeline
  end

  def parseToYaml(body)
    # add our global aliases before you transform to yaml to ensure we can lookup those
    YAML.load(body)
  end

  def loadGlobalAliases(globalAliasesPath)
    if File.exist?(globalAliasesPath)
      say_status 'success', "Global alias file found and loaded from #{globalAliasesPath}", :green

      @globalAliases = File.read(globalAliasesPath)
    else
      say_status 'ok', "No global alias file found at #{globalAliasesPath}", :white
      @globalAliases = ""
    end
  end

  def loadMainPipeline(mainPipelinePath)
    if File.exist?(mainPipelinePath)
      say_status 'success', "Main pipeline file found and loaded from #{mainPipelinePath}", :green

      @mainPipeline = @globalAliases + "\n" +  File.read(mainPipelinePath)
    else
      say_status 'ok', "No Main pipeline file found at #{mainPipelinePath}", :white
      @mainPipeline = ""
    end
  end

  def loadPartials(partialsFolder)
    say_status 'warning', "Partial folder not found at  #{partialsFolder}", :yellow unless Dir.exist?(partialsFolder)

    @partials = {}
    # our partials must start with _
    Dir.glob("#{partialsFolder}/**/_*.yaml") do |f|
      content = File.read(f)
      @partials[f] = @globalAliases + "\n" + content if content
    end
  end

  def globalAliases
    @globalAliases
  end

  def mainPipeline
    @mainPipeline
  end
end
