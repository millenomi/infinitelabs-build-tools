#!/usr/bin/en ruby

module ILabs

  class LocalePack
    attr_reader :locales, :base
  
    def initialize(path)
      @path = path
      Dir.open(path) do |d|
        # non-hidden (non-.) directories, and dirs not starting with '_' are locales
        @locales = d.entries.select do |x|
          x.match(/^[^\._]/) and File.directory?(File.join(path, x))
        end
      end
    
      base = File.join(@path, '_Base')
      @base = base if File.directory? base
    
    end
    
    def locale_dir_for(locale)
      File.join(@path, locale)
    end
    
    def locale_dirs
      locales.map { |l| locale_dir_for(l) }
    end
  
  end

end