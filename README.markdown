Rack XSLView README
===================

Configuration
-------------

This is how I would like it to work, but its not there yet:

<pre class="sh_ruby">
  use Rack::XSLView do
    noxsl ['/raw/', '/s/js/', '/s/css/']
    xslview '/path/alskjddf', 'test.xsl'
  end
</pre>


Resources
---------

* <http://github.com/docunext/Rack-XSLView>


