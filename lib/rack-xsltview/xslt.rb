require 'rack/mime'

module Rack
    class XSLView
        class Xslt
            attr_reader :views
            def initialize #:nodoc:
              @views = []
            end
        end
    end
end
