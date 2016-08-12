require "gem_syslibs/version"
require "bundler"
require "httparty"
module GemSyslibs
  class Syslibs
    ENDPOINT = "https://gyemsyslibs-api.herokuapp.com/search"
    PLATFORM = %x(uname)

    def check
      data = []
      definition = Bundler.definition
      definition.validate_ruby!
      deps = definition.dependencies
      missing = []
       deps.each do |g|
        exists = %x(gem list -i #{g.name})
         missing << g.name if exists.chop == "false"
       end
      req = HTTParty.post(ENDPOINT,

                               body: {
                                   packages: missing,
                                   os: PLATFORM.chop,
                               })

      success_data = JSON.parse req.body
      if success_data.size > 0
        libs =""
        packages =""
        success_data.each do |r|
          libs << r["libs"].join(" ")+" "
          packages << r["package"]['name']+" "

        end
        puts "you have to install the following system libraries #{libs} for #{packages} package(s)\n"
        #TODO: allow the gem to run install
        if PLATFORM == "Linux"
          puts "Run this command in terminal sudo apt-get install #{libs}"
        else
          puts "Run this command in terminal brew install #{libs}"
        end
      else
        puts "No system libraries needed."
      end

    end

  end
end
