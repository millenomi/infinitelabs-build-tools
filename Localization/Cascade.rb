#!/usr/bin/env ruby

require 'ilabs/locale_pack'
require 'osx/cocoa'

locale_dir = ARGV[0]

if not locale_dir or not File.directory? locale_dir
  $stderr.puts "error: #{locale_dir} isn't a directory." if locale_dir
  $stderr.puts "usage: Cascade <locale dir>"
  exit 1
end

pack = ILabs::LocalePack.new locale_dir

Dir.open(pack.base) do |dir|
  dir.entries.each do |file|
    next if file[0..0] == '.'
    file_path = File.expand_path File.join(pack.base, file)
    
  case file
    when /\.strings$/
      d = OSX::NSMutableDictionary.dictionaryWithContentsOfFile(file_path)
    
      pack.locale_dirs.each do |locale_dir|
      
        localized_file = File.expand_path File.join(locale_dir, file)
        
        if not File.exist? localized_file
          File.cp file_path, localized_file
        else
          d2 = OSX::NSDictionary.dictionaryWithContentsOfFile(localized_file)
          d2.each do |k,v|
            d[k] = v
          end
         
          File.open(localized_file, 'w') do |io|
            io << d.descriptionInStringsFileFormat
          end
        end
      end
      
    end #case
    
  end # dir.entries.each
end # Dir.open