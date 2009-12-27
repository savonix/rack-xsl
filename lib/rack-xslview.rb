require 'xml/libxml'
require 'xml/libxslt'


module Rack
  class XSLView
    def initialize(app, options)
      @my_path_info = String.new
      @app = app
      @myhash = {}
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
        unless @options[:passenv] == nil
          @options[:passenv].each { |envkey|
            if (mp = env[envkey])
              @myhash[envkey] = "#{mp}"
            end
          }
          @xslt.parameters = @myhash
        end
        status, headers, @response = @app.call(env)
        [status, headers, self]
      end
    end
    # Need to get entire response before transforming
    def each(&block)
      mycontent = ""
      @response.each { |part|
          mycontent += part
      }
      if ((mycontent.include? "<html") || !(mycontent.include? "<"))
        yield mycontent
      else
        @xslt.xml = mycontent
        yield @xslt.serve
      end
    end
    private
    def choosesheet(env)
      @options[:xslhash].each_key { |path|
        if env["PATH_INFO"].index(path)
          return @options[:xslhash][path]
        end
      }
      return false
    end
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

