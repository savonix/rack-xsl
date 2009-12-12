Rack XSLView README
===================

Configuration
-------------

This is how I would like it to work, but its not there yet:

<pre class="sh_ruby">
  # default xslt
  xslt = ::XML::XSLT.new()
  xslt.xsl = REXML::Document.new File.open('/path/to/output.xhtml10.xsl')
  omitpaths = ['/raw/', '/s/js/', '/s/css/']
  use Rack::XSLView, :myxsl => default_xsl, :noxsl => omitpaths do
    xslview '/path/alskjddf', 'test.xsl' # not working yet
  end
</pre>


Resources
---------

* <http://github.com/docunext/Rack-XSLView>


