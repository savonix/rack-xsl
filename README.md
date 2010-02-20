Rack XSLView README
===================

Summary
-------

A rack middleware for transforming XML with XSL.

Configuration
-------------

This is how I would like it to work, but its not there yet:

<pre class="sh_ruby">
# Create the xslt object
xslt = ::XML::XSLT.new()

# Set the default XSL
xslt.xsl = REXML::Document.new File.open('/path/to/output.xhtml10.xsl')

# Paths to exclude
noxsl = [/^\/raw/, '/s/js/', '/s/css/']

# NOTE: multiple stylesheets is still in planning
xslhash = { "/path/alskjddf" => "test.xsl",  /specific\.xml$/ => 'different.xsl' }
xslhash.default("/path/to/output.xhtml10.xsl")

# Use the middleware
use Rack::XSLView, :myxsl => default_xsl, :noxsl => noxsl, :xslhash => xslhash
</pre>


Resources
---------

* <http://www.docunext.com/wiki/Rack-XSLView>
* <http://github.com/docunext/Rack-XSLView>


Thanks
------

The rack-rewrite gem was very helpful in figuring out how to write rack middleware with lots of options.
