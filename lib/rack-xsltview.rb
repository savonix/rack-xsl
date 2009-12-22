require 'xml/libxml'
require 'xml/libxslt'


module Rack
  class XSLView
    def initialize(app, options, &xslt_block)
      @my_path_info = String.new
      @app = app
      @options = {:myxsl => nil}.merge(options)
      if @options[:myxsl] == nil
        @xslt = ::XML::XSLT.new()
        @xslt.xsl = File.join(File.dirname(__FILE__), 'output.xhtml10.xsl')
      else
        @xslt = @options[:myxsl]
      end
    end

    def call(env)
      if checknoxsl(env)
        @app.call(env)
      else
        if (mp = env["PATH_INFO"])
          @xslt.parameters = { "my_path_info" => "#{mp}" }
        end
        status, headers, @response = @app.call(env)
        [status, headers, self]
      end
    end
    def each(&block)
        @response.each { |x|
            if ((x.include? "<html") || !(x.include? "<"))
                yield x
            else
              @xslt.xml = x
              yield @xslt.serve
            end
        }
    end
    private
    def checknoxsl(env)
      @options[:noxsl].each { |path|
        if env["PATH_INFO"].index(path)
          return true
        end
      }
      return false
    end
  end
end

