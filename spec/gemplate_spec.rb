require 'spec_helper'
require 'fileutils'

describe Gemplate do
  describe '#new' do
    it 'creates cache objects' do
      expect(Gemplate.new).to be_an_instance_of Gemplate::Gem
    end
  end

  describe Gem do
    let(:subject) do
      Gemplate::Gem.new(
        name: 'gemplate',
        user: 'akerl',
        full_name: 'my_full_name',
        email: 'my_email@example.org',
        irc_stanza: 'irc://irc.example.org:6697#channel,password',
        license: 'MIT'
      )
    end

    before(:all) do
      Dir.chdir '.test'
      FileUtils.rm_rf 'gemplate'
    end
    after(:each) { FileUtils.rm_rf 'gemplate' }

    describe '#create' do
      it 'makes a directory from the template' do
        subject.create
        expect(Dir.exist? 'gemplate').to be_true
      end

      it 'raises an error if the directory already exists' do
        subject.create
        expect { subject.create }.to raise_error RuntimeError
      end

      it 'adds a license file' do
        subject.create
        expect(File.exist? 'gemplate/LICENSE').to be_true
      end

      it 'fails if you try to pull a non-existent license' do
        gem = Gemplate::Gem.new(
          name: 'gemplate',
          user: 'akerl',
          full_name: 'my_full_name',
          email: 'my_email@example.org',
          irc_stanza: 'irc://irc.example.org:6697#channel,password',
          license: 'MIT-3'
        )
        expect { gem.create }.to raise_error ArgumentError
      end

      it 'replaces placeholders in files' do
        subject.create
        expect(File.read 'gemplate/README.md').to_not match(/^REPO_NAME/)
      end

      it 'adjusts file names' do
        subject.create
        expect(File.exist? 'gemplate/gemplate.gemspec').to be_true
        expect(File.exist? 'gemplate/REPO_NAME.gemspec').to be_false
      end

      it 'makes the git repo' do
        subject.create
        expect(Dir.exist? 'gemplate/.git').to be_true
        expect(File.read 'gemplate/.git/config').to match(/remote "origin"/)
      end

      it 'configures the IRC key for Travis' do
        subject.create
        expect(File.read 'gemplate/.travis.yml').to match(/channels:/)
      end

      it 'warns if the Travis configuration fails' do
        gem = Gemplate::Gem.new(
          name: 'other_gem',
          user: 'akerl',
          full_name: 'my_full_name',
          email: 'my_email@example.org',
          irc_stanza: 'irc://irc.example.org:6697#channel,password',
          license: 'MIT'
        )
        expect(gem).to receive(:puts).with(/Travis IRC configuration failed/)
        gem.create
      end
    end
  end
end
