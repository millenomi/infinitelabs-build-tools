#!/usr/bin/env ruby

require 'csv'
require 'osx/cocoa'
include OSX

require File.join(File.dirname(__FILE__), 'ilabs/locale_pack')

USE_LOG = ENV['ILABS_L0ShowOnRequestLogging'] == 'YES'

if not ARGV[0] or not ARGV[1] or not File.exist? ARGV[0]
  $stderr.puts "Usage: CSVify.rb <File.csv> <Locales dir to create/update>"
  $stderr.puts "Note: files will be replaced, not merged."
  exit 1
end

pack = ILabs::MutableLocalePack.make_at_path ARGV[1]

def log(x); $stderr.puts(x) if USE_LOG; end

files = {}
current_file = nil
first = true
next_may_be_file_break = false
languages = nil

CSV.open(ARGV[0], 'r') do |row|
  log "\n\nProcessing row #{row.inspect}"
  
  if first
    log "Extracting languages from header row"
    languages = row[3..row.length]
    first = false
    
    log languages
    next
  end
    
  if not row[0] or row[0] == ''
    log "Empty row; next may be a file break"
    next_may_be_file_break = true
    next
  end
  
  if not current_file or (next_may_be_file_break and (not row[1] or row[1] == ''))
    log "Current file was #{current_file}, next may be file break: #{next_may_be_file_break}"
    log "Changing file to #{row[0]}"
    current_file = row[0]
    files[current_file] = {} unless files[current_file]
    next_may_be_file_break = false
    next
  end
  
  next_may_be_file_break = false
  
  next if not row[1] or row[1] == ''
  log "Loading string with key: #{row[0]}"
  
  i = 0
  languages.each do |l|
    log "Adding localized version to language #{l}: #{row[3 + i]}"
    files[current_file][l] = {} unless files[current_file][l]
    files[current_file][l][row[0]] = row[3 + i]
    i += 1
  end
end

files.each do |file_name, strings_by_language|
  log "Processing file named #{file_name}"
  
  strings_by_language.each do |language, strings|
    log "Processing language #{language} with:\n #{strings.inspect}"
    
    pack.add_locale language
    dir = pack.locale_dir_for(language)
    
    a = NSMutableDictionary.dictionary
    strings.each do |k, v|
      k = k.data.to_s
      v = v.data.to_s
      log "Original (Ruby strings) for key and value: #{k} [#{k.class}] = #{v} [#{v.class}]"
      
      k = NSString.alloc.initWithData_encoding(NSData.dataWithRubyString(k), NSUTF8StringEncoding)
      v = NSString.alloc.initWithData_encoding(NSData.dataWithRubyString(v), NSUTF8StringEncoding)
      
      log "Adding key #{k}, value #{v} of classes #{k.class}, #{v.class}"
      a[k] = v
    end
    
    File.open(File.join(dir, file_name), 'w') do |io|
      io << a.descriptionInStringsFileFormat
    end
  end
end
