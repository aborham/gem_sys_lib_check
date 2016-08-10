require "gem_syslibs/version"
require "bundler"
module GemSyslibs
  class Syslibs

    def check
      begin
      definition = Bundler.definition
      definition.validate_ruby!
      deps = definition.dependencies
      definition.resolve.materialize(deps,[])
      rescue Bundler::GemNotFound, Bundler::VersionConflict, StandardError => e
        # search the error message for gem name "Could not find gem '{gem_name} (~> version)' in any of the gem sources listed in your Gemfile or available on this machine."
        missing_gem = e.message.scan(/(?<=')(.*)(?=')/)

      end
      #puts definition.dependencies

    end

  end
end
