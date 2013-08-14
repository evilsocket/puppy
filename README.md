Puppy [![Gem Version](https://badge.fury.io/rb/puppy.png)](http://badge.fury.io/rb/puppy)
========================

Puppy is a tiny gem which will help you to perform easy object tracing and debugging.  
It simply defines a *trace* instance method on the Object class, once this method is invoked on an object of any kind, 
Puppy will start following and tracing like there's no tomorrow! :D

Methods
------------------------

Basically the only method that you are going to use is *trace* defined on every Object derived class, which can be invoked with
a set of options and with an optional code block to perform conditional tracing, original object instance, method and arguments 
list are passed to the code block.

Options are:

- :as - how to represent the instance as string, if a Symbol is given it will be invoked as a method, otherwise as a string. Default: :class 
- :caller - a boolean to enable or disable printing caller data. Default: true
- :step - if true stop the execution on each method invoked and wait for the user to press a key. Default: false
- :indent - if true method invocations will be indented as their nesting goes deeper. Default: true
- :stream - the stream to use to print the report while tracing the object, must overload the &lt;&lt; operator. Default: STDERR

Examples
------------------------

Basic usage.

    foo = 1.trace
    puts foo

Output:
    
    # Fixnum.to_ary() [puppy.rb:71:in `puts'] 
    # Fixnum.respond_to?(:to_ary) [puppy.rb:71:in `puts'] 
    # Fixnum.to_s() [puppy.rb:71:in `puts'] 
    1
    
Follow the object without reporting the caller and represent it using its variable name instead of its class. 

    bar = "something".trace :as => 'bar', :caller => false
    puts bar

Output:

    # bar.to_ary() 
    # bar.respond_to?(:to_ary) 
    # bar.to_s() 
    something

Use a block to conditionally trace only when arguments list is filled with something.

    count = 3.trace { |object,method,*args| args.size > 0 }
    puts count.size    # this won't be traced
    puts count.to_s(2) # this will

Installation and Usage
------------------------

You can verify your installation using this piece of code:

    gem install puppy

And

    require 'puppy'
    1.respond_to? :trace

License
------------------------

Released under the BSD license.  
Copyright &copy; 2013, Simone Margaritelli 

<http://www.evilsocket.net/>
All rights reserved.


