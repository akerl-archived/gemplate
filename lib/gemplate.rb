require 'travis'
require 'pathname'

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
    end
  end
end
