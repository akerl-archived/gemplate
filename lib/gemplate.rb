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

  TEMPLATE = "#{Pathname.new(__FILE__).parent.parent}/template"

  ##
  # Gem directory object
  class Gem
    def initialize(params = {})
      @name = params[:name]
      @user = params[:user]
      @full_name = params[:full_name]
      @email = params[:email]
      @irc_stanza = params[:irc_stanza]
      @license = params[:license]
    end

    def create
      create_directory
      process_variables
      make_repo
      configure_travis
    end

    private

    def create_directory
      fail "#{@name} already exists" if File.exist? @name
      FileUtils.cp_r TEMPLATE, @name
      Dir.chdir @name
    end

    def process_variables
    end

    def make_repo
    end

    def configure_travis
    end
  end
end
