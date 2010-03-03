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
xslt = XML::XSLT.new()

# Set the default XSL
xslfile = REXML::Document.new File.open('/path/to/output.xhtml10.xsl').read
xslt.xsl = xslfile

omitxsl = ['/raw/', '/s/js/', '/s/css/', '/s/img/']
passenv = ['PATH_INFO', 'RACK_MOUNT_PATH', 'RACK_ENV']

use Rack::XSLView,
  :myxsl => xslt,
  :noxsl => omitxsl,
  :passenv => passenv,
  :xslfile => xslfile,
  :reload => ENV['RACK_ENV'] == 'development' ? true : false

</pre>



Resources
---------

* <http://www.docunext.com/wiki/Rack-XSLView>
* <http://github.com/docunext/Rack-XSLView>


Thanks
------

The rack-rewrite gem was very helpful in figuring out how to write rack middleware with lots of options.
