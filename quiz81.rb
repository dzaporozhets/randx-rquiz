require 'ostruct'
require "rubygems"
require 'awesome_print'
require "yaml"
require 'hirb'

Hirb.enable
hash = YAML::load(File.open('quiz81.yml'))
table [hash]
