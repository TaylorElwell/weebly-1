require 'weebly/version'
require 'zip'
require 'colorize'

module Weebly
  class Weebly
    def self.create_site(sitename)
      Dir.mkdir sitename ||= puts 'Already exists'
    end
  end
end
