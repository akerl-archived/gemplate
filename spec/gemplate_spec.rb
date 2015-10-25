require 'spec_helper'
require 'fileutils'

TEST_GEM_NAME = 'gemplate-test'

describe Gemplate do
  describe '#new' do
    it 'creates gem objects' do
      expect(Gemplate.new).to be_an_instance_of Gemplate::Gem
    end
  end

  describe Gem do
    let(:subject) do
      Gemplate::Gem.new(
        name: TEST_GEM_NAME,
        user: 'akerl',
        full_name: 'my_full_name',
        email: 'my_email@example.org',
        license: 'MIT'
      )
    end

    before(:all) do
      Dir.chdir '.test'
      FileUtils.rm_rf TEST_GEM_NAME
    end
    after(:each) { FileUtils.rm_rf TEST_GEM_NAME }

    describe '#create' do
      it 'makes a directory from the template' do
        VCR.use_cassette('subject_create') do
          subject.create
        end
        expect(Dir.exist? TEST_GEM_NAME).to be_truthy
      end

      it 'raises an error if the directory already exists' do
        VCR.use_cassette('subject_create') do
          subject.create
          expect { subject.create }.to raise_error RuntimeError
        end
      end

      it 'adds a license file' do
        VCR.use_cassette('subject_create') do
          subject.create
        end
        expect(File.exist? "#{TEST_GEM_NAME}/LICENSE").to be_truthy
      end

      it 'fails if you try to pull a non-existent license' do
        VCR.use_cassette('bad_license') do
          gem = Gemplate::Gem.new(
            name: TEST_GEM_NAME,
            user: 'akerl',
            full_name: 'my_full_name',
            email: 'my_email@example.org',
            license: 'MIT-3'
          )
          expect { gem.create }.to raise_error ArgumentError
        end
      end

      it 'replaces placeholders in files' do
        VCR.use_cassette('subject_create') do
          subject.create
        end
        expect(
          File.read "#{TEST_GEM_NAME}/README.md"
        ).to_not match(/^REPO_NAME/)
      end

      it 'adjusts file names' do
        VCR.use_cassette('subject_create') do
          subject.create
        end
        expect(
          File.exist? "#{TEST_GEM_NAME}/#{TEST_GEM_NAME}.gemspec"
        ).to be_truthy
        expect(File.exist? "#{TEST_GEM_NAME}/REPO_NAME.gemspec").to be_falsey
      end

      it 'makes the git repo' do
        VCR.use_cassette('subject_create') do
          subject.create
        end
        expect(Dir.exist? "#{TEST_GEM_NAME}/.git").to be_truthy
        [
          /remote\.origin\.url/,
          /branch\.master\.remote=origin/,
          %r{branch\.master\.merge=refs\/heads\/master}
        ].each do |regex|
          expect(
            `git config -f #{TEST_GEM_NAME}/.git/config -l`
          ).to match(regex)
        end
      end
    end
  end
end
