module Rack
  class XSLView
    def initialize(app, options={})
      @app = app
      @options = {:myxsl => nil}.merge(options)
      if @options[:myxsl] == nil
        @xslt = ::XML::XSLT.new()
        @xslt.xsl = 'http://github.com/docunext/1bb02b59/raw/master/output.xhtml10.xsl'
      else
        @xslt = @options[:myxsl]
      end
    end

    def call(env)
        if env["PATH_INFO"].include? "/raw/"
            @app.call(env)
        else
            status, headers, @response = @app.call(env)
            [status, headers, self]
        end
    end
    def each(&block)
        @response.each { |x|
            if x.include? "<html"
                yield x
            else
              @xslt.xml = x
              yield @xslt.serve
            end
        }
    end
  end
end

