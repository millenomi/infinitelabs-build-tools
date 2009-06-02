#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'ilabs/locale_pack')
require 'osx/cocoa'
require 'fileutils'

USE_LOG = ENV['ILABS_L0ShowOnRequestLogging'] == 'YES'

locale_dir = ARGV[0]

if not locale_dir or not File.directory? locale_dir
  $stderr.puts "error: #{locale_dir} isn't a directory." if locale_dir
  $stderr.puts "usage: Cascade <locale dir>" #" [language to cascade to]"
  # $stderr.puts "If language to cascade to is unspecified, all languages will be cascaded to."
  exit 1
end

pack = ILabs::LocalePack.new locale_dir

Dir.open(pack.base) do |dir|
  dir.entries.each do |file|
    next if file[0..0] == '.'
    file_path = File.expand_path File.join(pack.base, file)
    $stderr.puts "Examining #{file_path}..." if USE_LOG
    
    case file
      when /\.strings$/
        d = OSX::NSMutableDictionary.dictionaryWithContentsOfFile(file_path)
    
        pack.locale_dirs.each do |locale_dir|
          
          localized_file = File.expand_path File.join(locale_dir, file)
          $stderr.puts "Will check localized version #{localized_file}" if USE_LOG
          
          if not File.exist? localized_file
            $stderr.puts "Not existing, will copy #{file_path} onto #{localized_file}" if USE_LOG
            FileUtils.cp file_path, localized_file
          else
            $stderr.puts "Updating strings from #{file_path} onto #{localized_file}" if USE_LOG
            d2 = OSX::NSDictionary.dictionaryWithContentsOfFile(localized_file)
            d2_new = OSX::NSMutableDictionary.dictionaryWithDictionary(d)
            d2.each do |k,v|
              d2_new[k] = v
            end
            
            #$stderr.puts " -- Strings for #{localized_file}:" if USE_LOG
            #$stderr.puts d2.descriptionInStringsFileFormat if USE_LOG
         
            File.open(localized_file, 'w') do |io|
              io << d2_new.descriptionInStringsFileFormat
            end
          end
        end
      
      end #case
    
  end # dir.entries.each
end # Dir.open