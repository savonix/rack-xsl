# Rack XSL README

Summary
-------

A rack middleware for transforming XML with XSL.

Configuration
-------------

This is how I would like it to work, but its not there yet:

<pre class="sh_ruby">
require 'xml/xslt'
require 'rack/xsl'

myxslfile = File.dirname(__FILE__) + '/app/views/layouts/xsl/html_main.xsl'
use Rack::XSLView,
  :myxsl => XML::XSLT.new(),
  :noxsl => ['/raw/', '/s/js/', '/s/css/', '/s/img/'],
  :passenv => ['PATH_INFO', 'RACK_MOUNT_PATH', 'RACK_ENV'],
  :xslfile => File.open(myxslfile) {|f| f.read },
  :excludehtml => false,
  :reload => true,
  :tidy => {  :doctype => 'omit',
    :numeric_entities => 1,
    :drop_proprietary_attributes => 1,
    :preserve_entities => 0,
    :input_encoding => 'utf8',
    :char_encoding => 'utf8',
    :output_encoding => 'utf8',
    :error_file => '/tmp/tidyerr.txt',
    :force_output => 1,
    :alt_text => '', 
    :tidy_mark => 0,
    :logical_emphasis => 1,
  }

</pre>


Resources
---------

* <http://www.docunext.com/wiki/Rack-XSLView>
* <http://github.com/docunext/Rack-XSLView>


Thanks
------

The rack-rewrite gem was very helpful in figuring out how to write rack middleware with lots of options.
