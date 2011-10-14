require 'spec_helper'
require 'stylus/configuration'

describe Stylus::Configuration do

  describe "copying the given options" do

    let(:options) { Hash.new }
    subject { Stylus::Configuration.new(options) }

    it "copies the debug flag if given" do
      options[:debug] = true
      subject.debug.should be_true
    end

    it "copies the compress flag if given" do
      options[:compress] = true
      subject.compress.should be_true
    end

    it "copies the nib flag if given" do
      options[:nib] = true
      subject.nib.should be_true
    end

    it "copies the filename flag if given" do
      options[:filename] = true
      subject.filename.should be_true
    end

    it 'coerces the plugins value'

    it 'coerces the paths value into an Array' do
      options[:paths] = 'some/path'
      subject.paths.should == ['some/path']
    end

    it 'coerces the imports value into an Array' do
      options[:imports] = 'reset'
      subject.imports.should == ['reset']
    end
  end

  describe '#to_options' do

    it 'exports the compress flag into the arguments hash' do
      subject.compress = true
      options = subject.to_options[:arguments]
      options[:compress].should be_true
    end

    it 'exports the paths array into the arguments hash' do
      subject.paths << 'one' << 'two'
      options = subject.to_options[:arguments]
      options[:paths].should == ['one', 'two']
    end

    it 'exports the filename option into the arguments hash' do
      subject.filename = 'foobar'
      options = subject.to_options[:arguments]
      options[:filename].should == 'foobar'
    end

    it 'exports the imports array' do
      subject.imports << 'file'
      imports = subject.to_options[:imports]
      imports.should == subject.imports
    end

    it 'exports the plugins hash' do
      subject.plugins = { :fingerprint => true }
      plugins = subject.to_options[:plugins]
      plugins.should == subject.plugins
    end

    context 'when the filename is present and the debug flag is on' do
      before do
        subject.filename = 'stylesheet'
        subject.debug = true
      end

      it 'sends the linenos flag as true' do
        options = subject.to_options[:arguments]
        options[:linenos].should be_true
      end

      it 'sends the firebug flag as true' do
        options = subject.to_options[:arguments]
        options[:firebug].should be_true
      end
    end
  end
end