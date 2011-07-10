# Copyright 2010 Savonix Corporation
# Author Albert L. Lash, IV
# License MIT
require 'rexml/document'
module Rack
  class XSL

    class RackXSLError < StandardError ; end

    def initialize(app, options)
      @app = app
      @options = {:myxsl => nil}.merge(options)
      if @options[:myxsl].nil?
        require 'rexml/document'
        @xslt = XML::XSLT.new()
        @xslt.xsl = REXML::Document.new '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"><xsl:import href="http://github.com/docunext/1bb02b59/raw/master/standard.html.xsl"/><xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" indent="yes"/></xsl:stylesheet>'
      else
        @xslt = @options[:myxsl]
        @xslt.xsl = REXML::Document.new @options[:xslfile]
      end
    end

    def call(env)
      # No matter what, @app will be called
      status, headers, body = @app.call(env)
      original_response = Array[status, headers, body]
      exluded_status = Array[204, 301, 302, 304]
      return original_response if exluded_status.include?(status) || body.nil?

      return original_response unless headers["Content-Type"].to_s.match(/(ht|x)ml/) 

      # If setup includes paths to exclude from xslt processing, check them
      checknoxsl(env) if @options[:noxsl]

      # Obtain entire request body, ensuring sure it can be processed
      myxml = getResponse(body)
	
      # One more check for an empty respone
      return original_response if myxml.empty?

      # Should XSL file be reloaded?
      if @options[:reload] == true
        @xslt     = XML::XSLT.new()
        @xslt.xsl = REXML::Document.new @options[:xslfile]
      end

      unless @options[:tidy].nil?
        input_xml = myxml.include?('http://www.w3.org/1999/xhtml') ? 0 : 1
        output = myxml.include?('http://www.w3.org/1999/xhtml') ? 'output_xhtml' : 'output_xml'
        @options[:tidy][:input_xml] = input_xml
        @options[:tidy][output.to_sym] = 1
        nuxml = ''
        nuxml = TidyFFI::Tidy.new(myxml, @options[:tidy]).clean
        myxml = nuxml
      end
      @xslt.xml = myxml

      # If setup includes env vars to pass through as params, do so
      unless @options[:passenv].nil?
        @myhash = {}
        @options[:passenv].each { |envkey|
          # Does env var exist?
          @myhash[envkey] = "#{env[envkey]}" if env[envkey]
        }
        @xslt.parameters = @myhash unless @myhash.empty?
      end

      # Perform the transformation
      newbody = Array.[](@xslt.serve)

      # If we've made it this far, we can alter the headers
      headers.delete('Content-Length')
      headers['Content-Length'] = newbody[0].length.to_s

      # Content type override?
      unless @options[:content_type].nil?
        headers["Content-Type"] = @options[:content_type]
      end

      # Cache control override?
      headers["Cache-Control"] = @options[:cache_control] if @options.has_key?(:cache_control)

      [status, headers, newbody]

    rescue RackXSLError
      # TODO Log: "Rack XSL not processed" if env['RACK_ENV'] == 'development'
      original_response
    end

    private
    def checknoxsl(env)
      @options[:noxsl].each { |path|
        raise RackXSLError if env["PATH_INFO"].index(path)
      }
    end
    def getResponse(body)
      newbody = []
      body.each { |part|
        # Only check the first chunk to ensure 1) its not HTML and 2) its XML
        checkForXml(part) if newbody.empty?
        newbody << part.to_s
      }
      return newbody.join('')
    end
    def checkForXml(x)
      # Abort processing if content cannot be processed by libxslt
      #puts "test for xml"
      #puts x[0]
      if RUBY_VERSION > '1.9'
        raise RackXSLError unless x[0] == '<'
      else
        raise RackXSLError unless x[0] == 60
      end
      #puts "end xml test"
      if @options[:excludehtml] == true
        raise RackXSLError if x.include? '<html'
      end
    end

    def choosesheet(env)
      # Not used yet, this may be used to match stylesheets with paths
      @options[:xslhash].each_key { |path|
        if env["PATH_INFO"].index(path)
          return @options[:xslhash][path]
        end
      }
      return false
    end
  end
end
