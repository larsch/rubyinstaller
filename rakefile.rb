#!/usr/bin/env ruby

# Ensure '.' is in the LOAD_PATH in Ruby 1.9.2
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))

# Load Rake
begin
  require 'rake'
rescue LoadError
  require 'rubygems'
  require 'rake'
end

# Add extensions to core Ruby classes
require 'rake/core_extensions'

# RubyInstaller configuration data
require 'config/ruby_installer'

# DevKit configuration data
require 'config/devkit'

# Added download task from buildr
require 'rake/downloadtask'
require 'rake/extracttask'
require 'rake/checkpoint'
require 'rake/env'
require 'rake/patch'

# Allow build configuration overrides if override/build_config.rb file
# exists in the RubyInstaller project root directory
begin
  require 'override/build_config'
rescue LoadError
end

Dir.glob("#{RubyInstaller::ROOT}/recipes/**/*.rake").sort.each do |ext|
  puts "Loading #{File.basename(ext)}" if Rake.application.options.trace
  load ext
end
