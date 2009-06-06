#!/usr/bin/en ruby

require 'fileutils'

module ILabs

  class LocalePack
    attr_reader :locales, :base, :path
    
    def update_locales
      Dir.open(path) do |d|
        # non-hidden (non-.) directories, and dirs not starting with '_' are locales
        @locales = d.entries.select do |x|
          x.match(/^[^\._]/) and File.directory?(File.join(self.path, x))
        end
      end
    end
    
    def initialize(path)
      @path = path
      update_locales

      b = File.join(@path, '_Base')
      @base = b if File.directory? b
    end
    
    def locale_dir_for(locale)
      File.join(@path, locale)
    end
    
    def locale_dirs
      locales.map { |l| locale_dir_for(l) }
    end
  
  end
  
  class MutableLocalePack < LocalePack
    def self.make_at_path(path)
      FileUtils.mkdir path unless File.directory? path
      self.new path
    end
    
    def add_locale(name)
      dir = locale_dir_for(name)
      FileUtils.mkdir dir unless File.directory? dir
      update_locales
    end
  end

end