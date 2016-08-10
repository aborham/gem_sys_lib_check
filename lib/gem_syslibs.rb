require "gem_syslibs/version"
require "bundler"
module GemSyslibs
  class Syslibs

    def check
      definition = Bundler.definition
      definition.validate_ruby!
      deps = definition.dependencies
      missing = []
       deps.map(&:name).each do |g|
        exists = %x(gem list -i #{g})
         missing << g if exists.chop == "false"
       end
      puts missing.inspect

    end

  end
end
