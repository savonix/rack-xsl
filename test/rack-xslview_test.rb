require 'test_helper'

class RackXslviewTest < Test::Unit::TestCase

  def call_args(overrides={})
    {'REQUEST_URI' => '/rlksdjfkj', 'PATH_INFO' => '/notsure', 'QUERYSTRING' => ''}.merge(overrides)

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
        @rack = Rack::XSLView.new(@app, :noxsl => omitpaths)
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
