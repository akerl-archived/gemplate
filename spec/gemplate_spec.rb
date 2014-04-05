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
      FileUtils.rm_rf 'my_gem'
      Gemplate::Gem.new(
        name: 'my_gem',
        user: 'my_user',
        full_name: 'my_full_name',
        email: 'my_email@example.org',
        irc_stanza: 'irc://irc.example.org:6697#channel,password',
        license: 'MIT'
      )
    end

    after(:all) { FileUtils.rm_rf 'my_gem' }

    describe '#create' do
      it 'makes a directory from the template' do
        subject.create
        expect(Dir.exist? 'my_gem').to be_true
      end

      it 'raises an error if the directory already exists' do
        subject.create
        expect { subject.create }.to raise_error RuntimeError
      end
    end
  end
end
