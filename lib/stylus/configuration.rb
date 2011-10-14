# A **Stylus::Configuration** object is responsible for grouping and
# coercing the supported options of the Stylus API - it holds the basic
# values as boolean flags and empty hashes/arrays and it accepts a hash of
# user supported options to combine with the default values.
#
# ###Available options###
# This object supports the following options:
#
# * `:compress`, Compress the generated output - defaults to `false`.
#
# * `:debug`, Check both the `firebug` and `linenos` options -
#    defaults to `false`
#
# * `:nib`, Adds nib to both the plugins Hash and the import Array -
#   defaults to `false`
#
# * `:filename`, the physical path for the given stylesheet, so the debug
#   information can be provided - defaults to `nil`.
#
# * `:paths`, an `Array` to be appended to `Stylus` load path,
#   empty by default.
#
# * `:imports`, a list of stylesheets to import on every compiled file.
#
# * `:plugins`, a `Hash` or `Array` of plugin name and arguments to be
#   used by `Stylus`.
#
# ### Argument extraction ###
# After configuring all the values, you can use the `to_options` method to
# return  a `Hash` with the 3 objects to be serialized and used by the
# underlying `Stylus` JS script used by this gem: the `:plugins` key with
# all the configured plugins, the `:imports` `Array` with all files to
# import and a `:arguments` `Hash` with the actual arguments for the
# `stylus.render` call inside the JavaScript code.
module Stylus
  class Configuration

    attr_accessor :compress, :debug, :nib, :filename
    attr_accessor :paths, :imports, :plugins

    alias :compress? :compress
    alias :debug? :debug
    alias :nib? :nib

    # `initialize` sets default values the flags and options and accepts
    #  an object to copy configuration values into the available options.
    def initialize(options = {})
      @compress = false
      @debug    = false
      @nib      = false
      @paths    = []
      @imports  = []
      @plugins  = Hash.new
      copy_values(options)
    end

    # Creates a new `Hash` with the predefined 3 arguments for the script
    # used by `Stylus` - the `:arguments` hash and the `:imports` and
    # `:plugins` collections.
    def to_options
      {
        :arguments => arguments_hash
        :imports => self.imports
        :plugins => self.plugins
      }
    end


    # Checking if we have both debug flag and the stylesheet physical path
    # to extract debug information.
    def debugging?
      self.debug && self.filename
    end

    protected

    def arguments_hash
      {
        :compress => self.compress?,
        :paths    => self.paths,
        :linenos  => self.debugging?,
        :firebug  => self.debugging?,
        :filename => self.filename
      }
    end

    def copy_values(hash)
      [:compress, :debug, :nib, :filename].each do |option|
        if hash.key?(option)
          self.send("#{option}=", hash.delete(option))
        end
      end

      [:paths, :imports].each do |collection|
        if hash.key?(collection)
          array = Array(hash.delete(collection))
          self.send("#{collection}=", array)
        end
      end
    end
  end
end