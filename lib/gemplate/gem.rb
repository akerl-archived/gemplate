# frozen_string_literal: true

require 'rugged'
require 'pathname'
require 'fileutils'
require 'curb'
require 'octoauth'
require 'octokit'

##
# Bootstrap tool for new gems
module Gemplate
  TEMPLATE = "#{Pathname.new(__FILE__).parent.parent.parent}/template".freeze
  LICENSE_URL = 'https://raw.githubusercontent.com/akerl/licenses/master'.freeze

  ##
  # Gem directory object
  class Gem
    def initialize(params = {})
      @name = params[:name]
      @user = params[:user]
      @org = params[:org]
      @full_name = params[:full_name]
      @email = params[:email]
      @license = params[:license]
      @authfile = params[:authfile] || :default
      @skip_github = params[:skip_github]
    end

    def create
      create_directory
      Dir.chdir @name
      add_license
      process_templates
      adjust_files
      make_repo
      Dir.chdir '..'
    end

    private

    def create_directory
      raise "#{@name} already exists" if File.exist? @name
      FileUtils.cp_r TEMPLATE, @name
    end

    def dependencies
      source = "#{TEMPLATE}/../gemplate.gemspec"
      dev_deps = File.read(source).lines.select { |x| x.include? 's.add_dev' }
      dev_deps.reject { |x| x.include? '# SKIP' }.join.strip
    end

    def add_license
      url = "#{LICENSE_URL}/#{@license}.txt"
      File.open('LICENSE', 'w') do |fh|
        license = Curl::Easy.perform(url)
        if license.response_code == 404
          raise ArgumentError, 'Invalid license name provided'
        end
        fh.write license.body_str
      end
    end

    def replacements
      [
        [/AUTHOR_NAME/, @user],
        [/LICENSE_NAME/, @license],
        [/FULL_NAME/, @full_name],
        [/REPO_NAME/, @name],
        [/EMAIL_ADDRESS/, @email],
        [/CURRENT_YEAR/, Time.now.strftime('%Y')],
        [/# DEV_DEPS/, dependencies]
      ]
    end

    def process_templates
      Dir.glob('**/*', File::FNM_DOTMATCH).each do |path|
        next unless File.file? path
        text = File.read path
        replacements.each { |regex, new| text.gsub! regex, new }
        File.open(path, 'w') { |fh| fh.write text }
      end
    end

    def adjust_files
      moves = [['repo_name.gemspec', "#{@name}.gemspec"],
               ['lib/repo_name.rb', "lib/#{@name}.rb"],
               ['spec/repo_name_spec.rb', "spec/#{@name}_spec.rb"]]
      moves.each { |original, new| FileUtils.move original, new }
    end

    def make_repo
      Rugged::Repository.init_at '.'
      return if @skip_github
      `git remote add origin "git@github.com:#{org || @user}/#{@name}"`
      `git config branch.master.remote origin`
      `git config branch.master.merge refs/heads/master`
      github_api.create_repo(@name, organization: org, has_wiki: false)
    end

    def org
      @org == @user ? nil : @org
    end

    def github_api
      return @api_client if @api_client
      auth = Octoauth.new note: 'gemplate', scopes: ['repo'], file: @authfile
      auth.save
      @api_client = Octokit::Client.new(access_token: auth.token)
    end
  end
end
