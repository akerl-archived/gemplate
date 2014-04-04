require 'travis'
require 'rugged'
require 'pathname'
require 'fileutils'
require 'curb'

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
  LICENSE_URL = 'https://raw.githubusercontent.com/akerl/licenses/master'

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
      process_templates
      adjust_files
      add_license
      make_repo
      configure_travis
    end

    private

    def create_directory
      fail "#{@name} already exists" if File.exist? @name
      FileUtils.cp_r TEMPLATE, @name
      Dir.chdir @name
    end

    def process_templates
      Dir.glob('**/*').each do |path|
        next unless File.file? path
        text = File.read path
        [[/AUTHOR_NAME/, @user], [/LICENSE_NAME/, @license],
         [/FULL_NAME/, @full_name], [/REPO_NAME/, @name],
         [/EMAIL_ADDRESS/, @email]].each { |regex, new| text.gsub! regex, new }
        File.open(path, 'w') { |fh| fh.write text }
      end
    end

    def adjust_files
      moves = [['REPO_NAME.gemspec', "#{@name}.gemspec"],
               ['lib/REPO_NAME.rb', "lib/#{@name}.rb"],
               ['spec/REPO_NAME_spec.rb', "spec/#{@name}_spec.rb"]]
      moves.each { |original, new| FileUtils.move original, new }
    end

    def add_license
      url = "#{LICENSE_URL}/#{@license}.txt"
      File.open('LICENSE', 'w') do |fh|
        text = Curl::Easy.perform(url).body_str
        fh.write text
      end
    end

    def make_repo
      Rugged::Repository.init_at '.'
      `git remote add origin "git@github.com:#{@user}/#{@name}"`
    end

    def configure_travis
      args = [
        'encrypt', '-p', '--add', 'notifications.irc.channels', @irc_stanza
      ]
      Travis::CLI.run(args)
    end
  end
end
