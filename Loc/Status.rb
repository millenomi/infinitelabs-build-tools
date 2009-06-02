#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), 'ilabs/locale_pack')
require 'osx/cocoa'
require 'fileutils'

# USE_LOG = ENV['ILABS_L0ShowOnRequestLogging'] == 'YES'

locale_dir = ARGV[0]

if not locale_dir or not File.directory? locale_dir
  $stderr.puts "error: #{locale_dir} isn't a directory." if locale_dir
  $stderr.puts "usage: State <locale dir> [locale to check]"
  exit 1
end

pack = ILabs::LocalePack.new locale_dir

strings = 0
translated_strings = {}

Dir.open(pack.base) do |dir|  
  dir.entries.each do |file|
    next if file[0..0] == '.'
    file_path = File.expand_path File.join(pack.base, file)
      
    case file
      when /\.strings$/
        d = OSX::NSDictionary.dictionaryWithContentsOfFile(file_path)
        strings += d.count
    
        pack.locale_dirs.each do |locale_dir|
          next if ARGV[1] and File.basename(locale_dir) != ARGV[1]
          
          shown_file_header = false
          
          localized_file = File.expand_path File.join(locale_dir, file)
          translated_strings[locale_dir] = 0 unless translated_strings[locale_dir]
          
          if File.exist? localized_file
            d2 = OSX::NSDictionary.dictionaryWithContentsOfFile(localized_file)

            d.each do |k,v|
              if d2[k] != v
                translated_strings[locale_dir] += 1
              else
                if ARGV[1]
                  puts "Unmodified in file #{file}:" unless shown_file_header
                  shown_file_header = true
                  puts " - key: #{k}"
                  puts " - original value: #{v}" if k != v
                end
              end
            end
          end
        end
      
      end #case
    
  end # dir.entries.each
end # Dir.open

puts "Total strings: #{strings}"
translated_strings.each do |k,v|
  puts "Locale #{k} has #{v} modified strings out of #{strings}."
end
