# This is where the magic happens, open the Object class and define
# the new #trace instance method for every object instances.
class Object
  # Starts tracing the object instance and prints every call to
  # its instance methods with given arguments.
  # Can be invoked with a code block to perform conditional tracing,
  # original object instance, method and arguments list are passed
  # to the code block.
  #
  # ==== Important Note:
  # If you assign the traced variable to another object which is
  # not traced, you will lose the ability to trace the new instance
  # unless you call the #trace method explicitly.
  #
  # ==== Examples:
  #
  #   # The following will print:
  #   #    Fixnum.to_ary() [puppy.rb:71:in `puts'] 
  #   #    Fixnum.respond_to?(:to_ary) [puppy.rb:71:in `puts'] 
  #   #    Fixnum.to_s() [puppy.rb:71:in `puts'] 
  #   #    1
  #   foo = 1.trace
  #   puts foo
  #
  #   # Trace the object without reporting the caller and represent 
  #   # it using its variable name instead of its #class, will print:
  #   # # bar.to_ary() 
  #   # # bar.respond_to?(:to_ary) 
  #   # # bar.to_s() 
  #   # something
  #   bar = "something".trace :as => 'bar', :caller => false
  #   puts bar
  #
  #   # Trace only when arguments list is filled with something.
  #   count = 3.trace { |object,method,*args| args.size > 0 }
  #   puts count.size    # this won't be traced
  #   puts count.to_s(2) # this will
  #
  # ==== Options:
  #
  # - :as - how to represent the instance as string, if a Symbol is given it will be invoked as a method, otherwise as a string. Default: :class 
  # - :caller - a boolean to enable or disable printing caller data. Default: true
  # - :step - if true stop the execution on each method invoked and wait for the user to press a key. Default: false
  # - :indent - if true method invocations will be indented as their nesting goes deeper. Default: true
  # - :stream - the stream to use to print the report while tracing the object, must overload the << operator. Default: STDERR
	def trace( options = {}, &block )
		Puppy::TracedObject.new( self, options, &block )
	end
end

module Puppy
  # This is the class which encapsulates every object instances once
  # the Object#trace method is invoked.
	class TracedObject 
    # Undefine every instance method to use the #method_missing trick.
		instance_methods.each do |m|
			undef_method m unless m == :object_id || m == :__id__ || m == :__send__ 
		end

		DEFAULTS = {
			:as     => :class,
			:caller => true,
			:step	  => false,
      :indent => true,
      :stream => STDERR
		}

    # Initializes the traced object instance with the original instance,
    # options and conditional tracing block.
		def initialize( obj, opts = {}, &block )
      @is_puppy_traced = true
			@object, @opts, @block = obj, DEFAULTS.merge(opts), block
      @stream = @opts[:stream]
		end

    # We need this to directly use #inspect on the traced object
    # without the invocation being traced itself.
    def inspect
      @object.send :inspect
    end

    # Make the user capable of tracing/untracing the object programmatically
    # without creating a new TracedObject instance.

    # Enables tracing. 
    def trace
      @is_puppy_traced = true
    end 

    # Disables tracing.
    def untrace
      @is_puppy_traced = false
    end

    # Here it goes, every method invoked on this object will trigger
    # TracedObject#method_missing since we've undefined every instance
    # method. This will make us able to print method call and arguments,
    # and then invoke the original method using Object#send on the
    # original instance.
		def method_missing( m, *args )
			begin
				if ( @block == nil || @block.call( @object, m, *args ) == true ) && @is_puppy_traced == true
          @stream << '# '
          @stream << ' ' * caller.size unless !@opts[:indent]

          as = @opts[:as]

          @stream << if as.is_a? Symbol
            @object.send as
          elsif as != nil
            as.to_s
          elsif
            @object.to_s
          end

          @stream << ".#{m}(#{args.map { |a| a.inspect }.join(', ')})"
          @stream << " [#{caller[0]}] " unless @opts[:caller] == false
          @stream << "\n"

					gets unless !@opts[:step]
				end

				@object.send m, *args
			rescue Exception => e
				raise
			end
		end
	end
end
