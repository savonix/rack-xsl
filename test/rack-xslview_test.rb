require 'test_helper'

class RackXslviewTest < Test::Unit::TestCase

  def call_args(overrides={})
    {'REQUEST_URI' => '/rlksdjfkj', 'PATH_INFO' => '/notsure', 'RACK_MOUNT_PATH' => '/something'}.merge(overrides)

  end

  def self.should_not_halt
    should "not halt the rack chain" do
      @app.expects(:call).once
      @rack.call(call_args)
    end
  end

  context 'Given an app' do
    setup do
      @app = Class.new { def call(app); true; end }.new
    end
  
    context 'Still learning how to write these tests...' do
      setup {
        omitpaths = [/^\/raw/, '/s/js/', '/s/css/']
        passenv = ['PATH_INFO', 'RACK_MOUNT_PATH']
        @rack = Rack::XSLView.new(@app, :noxsl => omitpaths, :passenv => passenv)
      }
      should_not_halt
    end
    context 'Trying out the xslhash' do
      setup {
        omitpaths = [/^\/raw/, '/s/js/', '/s/css/']
        xslhash = { "/path/alskjddf" => "test.xsl",  /specific\.xml$/ => 'different.xsl' }
        xslhash.default("/path/to/output.xhtml10.xsl")
        @rack = Rack::XSLView.new(@app, :noxsl => omitpaths, :xslhash => xslhash)
      }
      should_not_halt
    end
  end
end
