require 'travis'
require 'pathname'
require 'fileutils'

##
# Bootstrap tool for new gems
module Gemplate
  class << self
    ##
    # Insert a helper .new() method for creating a new Gem object

    def new(*args)
      self::Gem.new(*args)
    end
  end

  TEMPLATE = "#{Pathname.new(__FILE__).parent.parent}/template/"

  ##
  # Gem directory object
  class Gem
    def initialize(params = {})
      @name = params[:name]
      @author = params[:author]
      @email = params[:email]
      @travis_key = params[:travis_key]
      @license = params[:license]
    end

    def create
      create_directory
      copy_template
      process_variables
      make_repo
      configure_travis
    end

    private

    def create_directory
      fail "#{@name} already exists" if File.exists @name
      Dir.mkdir @name
      Dir.chdir @name
    end

    def copy_template
      FileUtils.cp_r TEMPLATE, '.'
    end

    def process_variables
    end

    def make_repo
    end

    def configure_travis
    end
  end
end
