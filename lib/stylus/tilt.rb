### Stylus template implementation for `Tilt`.
# It can be used by the `Rails` Asset Pipeline or `Sinatra` Applications.
require 'tilt'
require 'tilt/template'

module Tilt
  class StylusTemplate < Template
    self.default_mime_type = 'text/css'

    def prepare
    end

    def evaluate(scope, locals, &block)
      Stylus.compile(data, options)
    end
  end
end

Tilt.register Tilt::StylusTemplate, 'styl'