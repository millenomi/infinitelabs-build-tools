#!/usr/bin/env ruby

require 'csv'
require 'osx/cocoa'
require File.join(File.dirname(__FILE__), 'ilabs/locale_pack')

def pad_array!(a, length)
  if a.length < length
    (length-a.length).times do |i|
      a << ''
    end
  end
  
  a
end

USE_LOG = ENV['ILABS_L0ShowOnRequestLogging'] == 'YES'

if not ARGV[0] or not File.directory? ARGV[0]
  $stderr.puts "Not found or not a directory."
  $stderr.puts "Usage: CSVify.rb <Locales dir>"
  exit 1
end

pack = ILabs::LocalePack.new ARGV[0]
csv = CSV::Writer.create(STDOUT)

a = [ "Key, file name or comment", "Base value", "Comment" ]
locales = pack.locales
a.insert(-1, *locales)

ROW_LENGTH = a.length

csv << a

Dir.open(pack.base) do |base_dir|
  base_dir.entries.each do |file|
    next if file[0..0] == '.'
    next unless file =~ /\.strings$/
    
    file_path = File.expand_path File.join(pack.base, file)
    $stderr.puts "Examining #{file_path}..." if USE_LOG
    
    csv << pad_array!([file], ROW_LENGTH)
    csv << pad_array!(["(File comment goes here)"], ROW_LENGTH)
    csv << pad_array!([], ROW_LENGTH)
    
    d = OSX::NSDictionary.dictionaryWithContentsOfFile(file_path)
    localized_ds = {}
    locales.each do |locale|
      locale_dir = File.expand_path pack.locale_dir_for(locale)
      localized_file_path = File.join(locale_dir, file)
      localized_ds[locale] = OSX::NSDictionary.dictionaryWithContentsOfFile(localized_file_path)
    end

    d.each do |k,v|
      row = [k, v]
      locales.each do |locale|
        row << localized_ds[locale][k]
      end
      csv << row
    end
    
    csv << pad_array!([], ROW_LENGTH)
    
  end
end
