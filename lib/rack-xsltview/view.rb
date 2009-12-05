require 'rack/mime'

module Rack
    class XSLView
        class View
            attr_reader :views
            def initialize #:nodoc:
              @views = []
            end
        end
    end
end
