# MIT License
module Rack
  class XSLView
    def initialize(app, options)
      @my_path_info = String.new
      @app = app
      @myhash = {}
      @options = {:myxsl => nil}.merge(options)
      if @options[:myxsl] == nil
        @xslt = XML::XSLT.new()
        @xslt.xsl = REXML::Document.new '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"><xsl:import href="http://github.com/docunext/1bb02b59/raw/master/standard.html.xsl"/><xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/></xsl:stylesheet>'
      else
        @xslt = @options[:myxsl]
      end
    end

    def call(env)
      if checknoxsl(env)
        @app.call(env)
      else
        if @options[:reload] == true
          puts @options[:filepath]
          @xslt     = XML::XSLT.new()
          @xslt.xsl = REXML::Document.new @options[:xslfile]
        end
        unless @options[:passenv] == nil
          @options[:passenv].each { |envkey|
            if (mp = env[envkey])
              @myhash[envkey] = "#{mp}"
            end
          }
          @xslt.parameters = @myhash
        end
        status, headers, body = @app.call(env)

        # Obtain entire request body
        parts = ''
        body.each { |part| parts << part.to_s }

        # TODO Refactor
        if ((parts.include? "<html") || !(parts.include? "<"))
          [status, headers, body]
        else
          headers.delete('Content-Length')
          @xslt.xml = parts
          newbody = []
          newbody << @xslt.serve
          headers['Content-Length'] = newbody[0].length.to_s
          [status, headers, newbody]
        end
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

