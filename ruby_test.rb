require 'test_helper'

# Use include to add modules

class RubyTest < ActiveSupport::TestCase
  # Glossary
  #
  # first-class entities - They can be stored in variables, they are objects,
  # they can be created with .new()
  #
  # Mix a module into a class - Make the module's instance methods available to
  # all instances of the class
  #
  # receiver - Receiver.method(argument) => Receiver is what receives the method
  # message.
  context "Ruby" do
    should "Parallel assignment" do
      # Any assignment expression that has more than one l-value or r-value.

      # One l-value, multiple r-values
      x = 1,2,3; assert_equal [1,2,3], x

      x, = 1,2,3; assert_equal 1,x

      # Multiple l-values, one array r-value
      x,y,z = [1,2,3] # same as x,y,z = 1,2,3
      assert_equal 1, x
      assert_equal 2, y
      assert_equal 3, z

      x = [1,2]; assert_equal [1,2], x
      x, = [1,2]; assert_equal 1, x

      # different number of l- and r-values
      x,y,z = 1,2
      assert_equal 1,x
      assert_equal 2,y
      assert_equal nil,z

      x,y = 1,2,3 # 3 is not assigned
      assert_equal 1,x
      assert_equal 2,y

      # Parentheses in parallel assignment. The lefthand side can use
      #   parentheses for subassignment. If two or more l-values are enclosed in
      #   parentheses, they are initially treated as a single l-value. When the
      #   corresponding r-value has been determined, the rules of parallel
      #   assignment are applied recursively.
      x,(y,z) = 3,[4,5]
      assert_equal 3, x
      assert_equal 4, y
      assert_equal 5, z
      
      x,y,z = 3,[4,5]
      assert_equal 3, x
      assert_equal [4,5], y
      assert_equal nil, z

      # Parentheses with hashes
      x,(y,z) = 3,{4 => 5}
      assert_equal 3,x
      assert_equal(({4 => 5}), y)
      assert_equal nil, z

      x,(y,z) = 3, *{4 => 5}
      assert_equal 3,x
      assert_equal 4,y
      assert_equal 5, z




      # Return more than one value
      def return_two_values
        a = 2; b = 3
        [a,b]
      end
      assert_equal [2,3], return_two_values

      # See the splat operator for more assignments

    end

    should "unless::" do
      # Unless means: execute the LEFT unless the RIGHT evaluates to TRUE
      #
      # falsy values => The right is true, the left executes
      a = "not changed"; b = "changed"
      
      a = b unless false; assert_equal a,"changed"
      a = b unless [];    assert_equal a,"changed"
      a = b unless "";    assert_equal a,"changed"
      a = b unless nil;   assert_equal a,"changed"
      a = b unless {};    assert_equal a,"changed"

      # truthy values => anything else, the left doesn't execute
      a = "not changed"; b = "changed"

      a = b unless true;  assert_equal a,"not changed"
      a = b unless [3];   assert_equal a,"not changed"
    end

    should "super:: Chaining" do
      # It passes the arguments of the current method to the method with the
      #   same name in the superclass. (The superclass doesn't have to define
      #   it, it can inherit it from one of its ancestors.) It can be followed
      #   by arguments.
      #
      # If you use super as a bare keyword, all the args passed to the current
      # method are passed to the superclass method.
      class Point
        def initialize(x,y)
          @x = x
          @y = y
        end
      end

      class Point3D < Point
        def initialize(x,y,z)
          super(x,y)
          @z = z
        end
        def show
          "" << "#{@x} " << "#{@y} " << "#{@z}"
        end
      end

      p3d = Point3D.new(2,3,4)
      assert_equal "2 3 4", p3d.show

    end

    should "ensure::" do
      # Ensure that housekeeping details like closing files, disconnecting DB
      #   connections and committing transactions get done. Use it whenever you
      #   allocate a resource (file, DB connection) to ensure proper cleanup
      #   occurs. Even if there is an exception, the ensure clause gets called.
      #
      # The ensure clause can replace the running exception with another one, or
      # switch the current return value with another one.
      def ensure_returns
        begin
          return 1
        ensure
          return 2
        end
      end
      assert_equal 2, ensure_returns
    end

    should "and::" do
      # Using this pattern wee can guarantee that the result we return will be
      #   valid, even if an unexpected error is raised
      def increase_number(number)
        number.is_a?(Fixnum) ? number += 1 : (raise ArgumentError)
      end

      def increment(number)
        begin
          return_value = increase_number(number) and return return_value  #successful
          # If the below executes, something went wrong.
        rescue ArgumentError => e
          return e.class
        end
      end

      assert_equal 3, increment(2)
      assert_equal(ArgumentError, increment("error"), "It wasn't a number")
    end

    should "for...in..." do
      @mestres = ""
      for mestre in ["bimba", "pastinha", "camisa"]
        @mestres << mestre << " "
      end
      assert_equal "bimba pastinha camisa ", @mestres
    end
  end

  context "Kernel" do
    should "method_missing:: obj.method_missing(symbol [, *args] ) => result " do
      # symbol is the symbol for the method called, and args are any arguments
      #   that were passed to it
      class Roman
        def roman_to_int(str)
          case str.to_s
          when 'i' then 1
          when 'ii' then 2
          when 'iii' then 3
          end
        end
        def method_missing(method)
          roman_to_int(method)
        end
      end

      r = Roman.new
      assert_equal 3, r.iii
    end
  end

  context "Operators" do
    should "||=::" do
      def set_results(results = nil)
        results ||= []
        # same thing as: results = results || [] same thing as: results = [] if
        #   results.nil?
      end
      assert_equal [], set_results
      assert_equal [], set_results(false)
      assert_equal [1,2,3], set_results([1,2,3])
    end

    should "*:: The splat operator" do
      # Uses Array Expansion Syntax. It lets us group together all remaining
      #   parameters into a single array variable

      # 1 - ASSIGNMENT: * expands r-value arrays and hashes
      pet1, pet2, pet3 = 'duck', *['dog','cat']
      assert_equal 'duck', pet1
      assert_equal 'dog', pet2
      assert_equal 'cat', pet3
      
      pet1, pet2, pet3 = 'duck', *{'dog' => 'cat'}
      assert_equal 'duck', pet1
      assert_equal ['dog','cat'], pet2
      assert_equal nil, pet3

      
      # 2 - ASSIGNMENT: * on l-values contracts values into arrays
      pet1, *other_pets = 'duck','dog','cat'
      assert_equal 'duck', pet1
      assert_equal ['dog','cat'], other_pets


      # 3 - convert a non-nested array to hash
      vehicles = [ :planes, 21, :cars, 36 ]
      vehicles_hash = Hash[*vehicles]
      assert_equal({ :planes => 21, :cars => 36 }, vehicles_hash)
      # convert a nested array
      vehicles_nested = [[:planes, 21], [:cars, 36]] # same as vehicles_hash.to_a
      vehicles_hash_unnested = Hash[*vehicles_nested.flatten]
      assert_equal({ :planes => 21, :cars => 36 }, vehicles_hash_unnested)

      # 4 - Convert Hash to array by exploding hash
      vehicles_array = *{ :planes => 21, :cars => 36 }
      assert_same_elements [ [:planes, 21], [:cars, 36] ], vehicles_array

      # 5 - Use in a case statement - explode array
      WILD = %w( lion ñu )
      TAME = %w( cat cow )
      def determine_continent(animal)
        case animal
        when *WILD then "Africa"
        when *TAME then "Europe"
        end
      end
      assert_equal "Africa", determine_continent("ñu")

      # 6 - Array#* == Array#join if supplied a string
      array = %w( join this sentence )
      assert_equal "join—this—sentence", ( array * '—')

      # 7 - Define methods that take an unlimited number of arguments
      def method_with_unlimited_arguments(*args)
        true
      end
      some_ints = [1,2,3]
      assert method_with_unlimited_arguments(2)
      assert method_with_unlimited_arguments(some_ints)
      assert method_with_unlimited_arguments([1,2,3])

      # * repeats a string if followed by an integer.
      repeated = 'hola' * 2
      assert_equal "holahola", repeated
    end

    should "!!::Double negation" do
      # Used to force an object into an explicit true/false. Usually not
      # necessary
      def is_this_true?
        @fishy_variable
      end
      @fishy_variable = nil
      assert_false @fishy_variable, "The variable is evaluated as false"
      assert_not_equal false, !@fishy_variable, "Even thought it isn't actually <false>"
      assert_equal false, !!@fishy_variable, "The double negation coerces it into <false>"

    end

    should "<<:: Append altering the left operand" do
      greeting = "A bananeira"
      greeting << " caiu"
      assert_equal "A bananeira caiu", greeting
    end
    
    should "%::formatting interpolation" do
      assert_equal "9.50", ("%.2f" % 9.5)

      assert_equal "<p>hello</p>", ( "<%s>%s</%s>" % %w{p hello p} )
    end
  end

  context "Methods & Classes" do
    setup do
      class Point
      end

    end
    should "Singleton Method::" do
      # Singleton Method - Method that is defined for only a single object
      # rather than a class of objects.
      def Point.sum
        # sum is a singleton method on an object Point
      end

      # The singleton methods of an object are instance methods of its singleton
      # class.
      class Iuna 
        def self.don ; "don"; end
        def self.yin ; "yin"; end

        def self.singleton_class
          class << self
            self
          end
        end
      end
      iuna = Iuna.new
      assert_contains iuna.class.singleton_class.instance_methods(false), "don"
      assert_contains iuna.class.singleton_class.instance_methods(false), "yin"
    end

    should "Class methods::" do
      # Class methods are singleton methods of an object of Class type
      class Iuna
        def self.don ; "don"; end
        def self.yin ; "yin"; end
      end
      assert_same_elements ["don","yin"], Iuna.singleton_methods(false)
    end

    should "define_method(meth_name, meth_body):: Defines an instance method in the receiver" do
      # It expects a Symbol as meth_name and it creates a method with that name,
      # using the associated "block" as the method body. Instead of a block, it
      # can also be a Proc or a Method object. The block is evaluated using
      # instance_eval.
      class A
        def create_method(name, &block)
          self.class.send(:define_method, name, &block)
        end
        define_method(:paco) { 3 }
      end

      a = A.new
      assert_equal 3, a.paco

      a.create_method(:camaron) { 4 }
      assert_equal 4, a.camaron

      # you can do the same thing with class_eval
      A.class_eval { define_method(:camaron2){ 3 }}
      assert_equal 3, a.camaron2
    end

    should "Eigenclass:: or singleton class" do
      
      class << Point # opening the singleton class
        def class_method1
          # instance method of the eigenclass, and also class method of Point.
        end
        def class_method2
        end
      end

      # Alternative Syntax: If you open the eigenclass of a class object within
      # the definition of a class itself, you can use self instead of the name
      # of the class
      class Point
        # instance methods go here
        class << self # opening the singleton class
          # class methods go here as instance methods of the eigenclass
          def class_method3

          end
        end
      end
    end

    should "method visibility public:: private:: protected::" do
      # methods are normally public (except the initialize method, which is
      # private).

      # private methods are implicitely invoked on self, and may not be
      # explicitly invoked on an object.

      # public, private and protected only apply to methods. Instance & class
      # variables are encapsulated and thus, behave as private (the only way to
      # make an instance variable accessible from outside a class is defining an
      # accessor method). Constants behave as public (there is no way of making
      # them unaccessible to outside use).


      # A protected method is like a private method (it can only be invoked from
      # within the implementation of a class or its subclasses) but it may be
      # explicitely invoked on any instance of the class.
      #
      class Esquiva
        def patada(esq) esq.esquivar end

        protected
        def esquivar() "esquivando" end

      end
      esq1 = Esquiva.new
      esq2 = Esquiva.new

      assert_equal "esquivando", esq1.patada(esq2), "Calling protected method"
      assert_raise NoMethodError do
        esq1.esquivar # esquivar is protected
      end

      #      def safe_send(receiver, method, message) # regular send bypasses visibility rules
      #        eval "receiver.#{method}"  # receiver.method
      #      rescue => e
      #        puts "#{message}: #{e}"    # This is my message: NoMethodError
      #      end
      #
      #      visibility = ARGV.shift || "public"
      #
      #
    end

    should "Subclassing <:: or inheritance" do
      # Used to extend a class with the methods in another class. When we define
      # a class, we may specify that it extends—or inherits from—another class,
      # known as the superclass.
      #
      # class Gem < Ruby     #=> Gem is a subclass of Ruby. Ruby is the superclass of Gem
      # If you do not specify a superclass, the class implicitly extends Object.

      # < is a boolean operator
      assert String < Comparable, "String inherits from Comparable"

      assert_false String < Integer, "String doesn't inherit from Integer"
    end

  end

  context "Module" do
    # Modules are classes that can't be instantiated or subclassed. They can be
    # used as namespaces (to group related methods or constants) and as mixins
    # (to include instance methods in classes).
    setup do
      module InstanceMethods
        def an_instance_method; self.class ;end
      end
      module ClassMethods
        def a_class_method; self ;end
      end
    end
    should "include:: and extend::  can only be called on A MODULE " do
      # include: Adds module methods as INSTANCE METHODS.
      #
      # extend: Adds all module methods ONLY TO THE INSTANCE it's called on.
      #
      # If you want to access a method defined inside a class
      

      class MyClass
        include InstanceMethods
        extend ClassMethods # ClassMethods == SingletonMethods
        # If extend is called inside the class, it adds module methods as CLASS
        # METHODS (because adding instance methods to its eigenclass makes them
        # class methods).
      end

      my_class_instance = MyClass.new
      assert_equal MyClass, my_class_instance.an_instance_method, "Instance methods are now available"
      assert_equal MyClass, MyClass.a_class_method, "Class methods are now available"

      # Using extend outside the class definition, adds the methods as singleton
      # methods (meaning, only to that instance of the class).
      obj_instance = Object.new
      obj_instance.extend InstanceMethods # Other object instances won't have access to "an_instance_method"
      assert_equal Object, obj_instance.an_instance_method, "Instance methods are now available"
    end

    should "include:: and extend:: simplified" do
      module InstanceMethodsWithExtend
        # Called everytime a module is included. Same thing with extended. base
        # is also known as klass
        def self.included(base)
          base.extend(ClassMethods)
        end
      end
      class MyClass
        include InstanceMethodsWithExtend
      end

      my_class_instance = MyClass.new
      assert_equal MyClass, my_class_instance.an_instance_method, "Instance methods are now available"
      assert_equal MyClass, MyClass.a_class_method, "Class methods are now available"
    end
    
    should "require::" do
      # It's used for loading files. You may need to include after requiring (if
      # they contain modules).
    end
  
    should "const_get:: mod.const_get(sym) => obj" do
      # Returns the value of the named constant in mod.
      assert_equal 3, Math.const_get(:PI).truncate
    end

    should "class << self::" do
      class Capoeira
        def an_instance_method;end

        class << self
          def a_class_method;end
        end

        def self.another_class_method;end
      end
      assert_same_elements %w( a_class_method another_class_method), Capoeira.public_methods - Capoeira.superclass.public_methods

    end

  end

  context "Literals" do
    should "String literals" do
      # There are four matching delimiters: [], {}, (), <>. Any other delimiter
      # used has to be repeated: !!,||, "", '', //,++,**,:: etc.

      # No interpolation: '' or %q
      assert_equal "paco", 'paco'
      assert_equal "paco", %q[paco]
      assert_equal "paco", %q{paco}
      assert_equal "paco", %q(paco)
      assert_equal "pa<c>o", %q<pa<c>o>, "Because they are paired, matching delimiters can be nested"
      assert_equal "pa{c}o", %q/pa{c}o/
      assert_equal "pa_co", %q_pa\_co_

      # Interpolation "", %Q or just %
      assert_equal "4", "#{2*2}"
      assert_equal "4", %Q+#{2*2}+
      assert_equal "4", %|#{2*2}|

      # Here documents
      multiline_no_dash = <<termina_con_esto
        Hola
        Paco
termina_con_esto
      assert_equal "        Hola\n        Paco\n", multiline_no_dash

      multiline_with_dash = <<-termina_con_esto
        Hola
        Paco
      termina_con_esto
      assert_equal "        Hola\n        Paco\n", multiline_with_dash
    end

    should "Array literals (arrays of strings)" do
      # No interpolation %w
      assert_equal ['a', 'b', 'c'], %w[a b c]
      assert_equal ['(', '[', '{', '<'], %w| ( [ { < |
      assert_equal ['\s'], %w(\s)

      # Interpolation %W
      assert_equal [' '], %W(\s)
      assert_equal ["\s"], %W(\s)
      a = 3
      assert_not_equal 3, %W( a ), %q(it doesn't work, you have to use #{a})
    end

    should "Symbol literals" do
      assert_equal :"hola hermano", %s(hola hermano)
    end
  end

  context "Blocks, Procs, Lambdas and Methods" do
    # Blocks are syntactic structures; they are NOT objects, and cannot be
    # manipulated as objects. It's possible to create an object that represents
    # a block: a proc or a lambda.
    should "not assign a block to a variable" do
      # my_block = { |x| x*x } #=> SyntaxError use this instead: my_block =
      # lambda{ |x| x*x } my_block.call
    end
    
    should "Blocks: use yield()" do
      # The value of the "assert" is the value of the expression in the block
      # (x>3), using "number" as a parameter for x.

      def send_a_number(number) # "send_a_number" is the function, "number" is the argument of the function
        # The presence of yield means a block has to be passed to the function.
        yield(number) ? true : false # "number" is the argument of the yield, it will become the argument of the block
      end

      assert send_a_number(4) { |x| x > 3}
      assert_false send_a_number(2) { |x| x > 3}
    end

    should "a block refers to outer variables, not inner" do
      def execute_the_block_three_times_with_local_variable
        my_var = 100 #var in the context from which it is called
        yield
        yield
        yield
      end
      my_var = 5 #var in the same context as the block
      execute_the_block_three_times_with_local_variable { my_var += 1 }
      assert_equal 8, my_var
    end
    should "&:: creates procs implicitely. It converts Blocks into Procs and viceversa" do
      def convert_block_to_proc(&block)# The unary ampersand operator
        block
      end

      external_proc = convert_block_to_proc { |x|  x > 3 }

      assert external_proc.call(4), "the block returns true"
      assert_false external_proc.call(1), "the block returns false"

      assert_raise ArgumentError do
        [1,4,7].any? external_proc # any? expects a block and we're sending it a proc
      end

      assert [1,4,7].any?(&external_proc), "We turn the proc back into a block"
    end
    
    should "Proc:: use call(). proc { |...| block } => a_proc" do
      # Procs have block-like behavior, they are objects. Greatest feature =>
      # Procs can be saved in variables.
      def convert_block_to_proc_using_ampersand(&block)
        block
      end
      def convert_block_to_proc_using_proc_new(&block)
        Proc.new(&block)
      end
      proc_with_ampersand = convert_block_to_proc_using_ampersand { "&" }
      proc_with_proc_new = convert_block_to_proc_using_proc_new { "Proc.new()" }
      assert_equal "&", proc_with_ampersand.call
      assert_equal "Proc.new()", proc_with_proc_new.call
    end


      
    should "Proc:: Pass a Proc as an argument" do
      # Calling a proc is like yielding to a block
      Array.class_eval do
        def iterate!(code) # note, no &. A Proc is just a regular parameter
          self.each_with_index do |n,i|
            self[i] = code.call(n)
          end
        end
      end
      square = Proc.new do |n|
        n**2
      end
      assert_equal [1,4,9,16], [1,2,3,4].iterate!(square)
    end

    should "defined?:: checks if a variable is defined" do
      assert_false defined?(d), "d is not defined"
    end

    should "block_given?:: checks to see if a block is sent along with the call to the function" do
      def did_you_pass_me_a_block?()
        block_given? ? yield : "No block"
      end

      assert_equal "No block", did_you_pass_me_a_block?
      assert_equal "Yes, I did", did_you_pass_me_a_block? { 'Yes, I did' }
      proc = Proc.new { 'Not really. I passed you a proc' }
      assert_equal "Not really. I passed you a proc", did_you_pass_me_a_block?(&proc)
    end

    should "to_proc::" do
      # If you send something that isn't a Proc to the & unary op. It will try
      # to convert it into a proc by using its to_proc method, and then convert
      # it into a block

    end

    should "Lambda:: lambda { |...| block } => a_proc | proc { ... } is a synonym" do
      # Lambdas have method-like behavior, but they are instances of class Proc.
      # Calling a lambda is like invoking a method.

      saved_proc_with_error = Proc.new { return 3 }
      assert_raise LocalJumpError do
        saved_proc_with_error.call # Can't call a proc that returns a value
      end

      # either remove the return, or use a lambda
      saved_proc = Proc.new { 3 } # remove the return
      assert_equal 3, saved_proc.call
      
      saved_lambda = lambda { return 3 } # Using a lambda
      assert_equal 3, saved_lambda.call
    end

    should "Lambda and Proc differences" do
      # 1) Lambdas don't check the number of parameters passed when called.
      # Procs do.
      checks_params = lambda { |one, two, three| "#{one} #{two} #{three.class}" }
      assert_raise ArgumentError do
        checks_params.call(1,2)
      end

      does_not_check_params = Proc.new { |one, two, three| "#{one} #{two} #{three.class}" }
      assert_equal "1 2 NilClass", does_not_check_params.call(1,2)

      # 2) Lambdas have diminutive returns. A Proc will stop a method and return
      # the value provided, lambdas will return their value to the method and
      # let the method continue on.
      def proc_return
        Proc.new { return "Proc.new"}.call #stop here
        return "proc_return method finished"
      end
      def lambda_return
        lambda { return "lambda"}.call
        return "lambda_return method finished" #stop here
      end

      assert_equal "Proc.new", proc_return # Procs are code snippets, not methods.
      assert_equal "lambda_return method finished", lambda_return
      # lambdas are methods: they check the number of arguments and don't
      # override the calling method's return
    end

    should "block-arguments::" do
      # #block-arguments are like regular arguments. They get assigned when the
      # lambda is called
      methods = %w( upcase! chop! )
      var = "hola"
      block = lambda { |responder| methods.each { |method| responder.send(method) } }
      block.call(var) # var becomes "responder" block-argument.
      assert_equal "HOL", var
    end

    should "Method::" do
      # Useful if you want to pass a method as a block. It's like a lambda but
      # without being anonymous
      Array.class_eval do
        def iterate!(code) # note, no &. A Proc is just a regular parameter
          self.each_with_index do |n,i|
            self[i] = code.call(n)
          end
        end
      end

      def square(n)
        n**2
      end
      assert_equal [1,4,9,16], [1,2,3,4].iterate!(method(:square))

    end

  end

  context "Iterators" do
    should "Array.map:: also called Enum.collect" do
      # map is an iterator that invokes the block that follows it once for each
      # element in the array.
      assert_equal [1,4,9], [1,2,3].map { |x| x*x }, "Array"
      assert_equal [2,4,6], (1..3).map { |x| x*2 }, "Range"
      assert_equal [2,3,4], [1,2,3].map(&:succ)
    end

    should "inject::" do
      # Invokes the associated block with two arguments. The first argument is
      # an accumulator convert previous iterations. The second is the next
      # element. The return value becomes the first block-argument for the next
      # iteration (except for the last iteration). The initial value of the
      # accumulator is either the arg to inject, or the first element of the
      # enumerable object.
      data = [2,5,3,4]
      sum = data.inject { |sum, current_value| sum + current_value}
      assert_equal 2 + 5 + 3 + 4, sum

      multiply = data.inject(1) { |accum, current_value| accum * current_value }
      assert_equal 1 * 2 * 5 * 3 * 4, multiply

      maximum = data.inject { |max, current_value| max > current_value ? max : current_value}
      assert_equal 5, maximum

      # injecting an empty hash converts a nested array into a hash. It's better
      # to use hash_with_splat, but if it's nested with two or more leves it
      # might give errors, then you might want to use flatten(1).
      nested_array = [ [1,2],[3,4],[5,6] ]
      new_hash = nested_array.inject({}) do |hash, (key, value)| #   hash,(key,value) = {},[1,2]
        hash[key] = value
        hash
      end
      hash_with_splat = Hash[*nested_array.flatten]
      assert_same_elements(({5 => 6, 1 => 2, 3 => 4}),new_hash)
      assert_same_elements(({5 => 6, 1 => 2, 3 => 4}), hash_with_splat )

      # inject an array
      nested_hash ={%w( à ä á) => 'a', %w( é è ê ë) => 'e'}
      convert, to = nested_hash.inject(['','']) do |array,(key,value)| # array,(key,value) = ['',''], *{['à','ä','á'] => 'a'}
        array[0] << key * ''
        array[1] << value * key.size
        array
      end
      assert_equal 'àäáéèêë',convert
      assert_equal 'aaaeeee',to

    end

    should "each::" do
      hash = { :hola => 'oi', :adios => 'adeus'}
      joined_hash = ""
      hash.each { |key,value| joined_hash += (key.to_s + value)} # key, value = [key, value] parallel assignment
      assert_equal "holaoiadiosadeus".length, joined_hash.length

      # When using Hash.each with two block-parameters, it's the same as using
      # Hash.each_pair.
    end

  end

  context "Array" do

    should "creation" do
      assert_equal [3], Array(3) # Alternative syntax
    end

    should "join::" do
      assert_equal "a-b-c", %w(a b c).join("-")
      assert_equal "a-b-c", %w(a b c) * "-", "see the splat operator"
      assert_equal "A-B-C", %w(a b c).collect{ |letra| letra.upcase! }.join("-")
    end
  end

  context "Hash" do
    setup do
      @vehicles_hash = { :cars => 36, :boats => 8, :trains => 12, :planes => 21 }
    end

    should "select::" do
      # Returns a new ARRAY consisting of [key,value] pairs for which the block
      # returns true
      vehicles_array = [[:cars, 36], [:planes, 21]]
      assert_same_elements vehicles_array, @vehicles_hash.select { |key, value| value > 20 }
    end

    should "values_at::" do
      # Return an array containing the values associated with the given keys
      assert_equal [36, 8], @vehicles_hash.values_at(:cars, :boats)
    end

    should "merge::" do
      h1 = { :a => 100, :b => 200 }
      h2 = { :b => 300, :c => 400 }
      h3 = h1.merge(h2)
      assert_equal Hash[ :a => 100, :b => 300, :c => 400 ], h3
    end

    should "delete:: deletes and returns the value matching the key" do
      h1 = { :a => 100, :b => 200 }
      assert_equal 100, h1.delete(:a)
      assert_equal Hash[:b => 200], h1
    end

    should "shift::" do
      # removes a key-value pair from the hash and returns it as a two-item
      # array (or the hash's default value, if it's empty)
      h = { 1 => 'a', 2 => 'b', 3 => 'c'}
      item = h.shift
      assert_equal [1,'a'], item
      assert_equal(({2 => 'b', 3 => 'c'}), h)
    end

    should "symbolize_keys::" do
      # Return a new hash with all keys converted to symbols.
       foo = { 'name' => 'Gavin', 'wife' => :Lisa }
       assert_equal(({ :name => 'Gavin', :wife => :Lisa }), foo.symbolize_keys)
    end

    should "stringify_keys::" do
      # Return a new hash with all keys converted to strings.
       foo = { :name => 'Gavin', :wife => :Lisa }
       assert_equal(({ 'name' => 'Gavin', 'wife' => :Lisa }), foo.stringify_keys)

    end
  end

  context "String" do
    should "concatenate:" do
      # #It's better to append than to build new ones
      str = ''
      a = 'Nava'
      b = 'laga'
      c = 'mella'
      assert_equal 'Navalagamella', str << a << b << c, "Better"
      str = ''
      assert_equal 'Navalagamella', str << "#{a}" << "#{b}" << "#{c}"
    end
  end

  context "Enumerable" do
    # Enumerable is a mixin that allows traversal, searching and sorting
    # methods. The requirements are that the class that mixes it in must have a
    # method "each()", and in some cases also the operator <=> (for max, min,
    # sort)
    #
    # Classes that implement each: Array, Hash, Range, String
    should "each::" do
      #      (5..10).each
    end

    should "any?:: enum.any? [{|obj| block } ] => true or false; ^::" do
      # Passes each element of the collection to the given block and it returns
      # TRUE if at least ONE of the collection members is not false or nil. It
      # expects a block. If no block is passed any? returns TRUE if at least one
      # element is not nil
      assert %w( ant bear cat ).any? {|word| word.length >= 3}

      def received_arguments?(*args)
        args.any?
      end
      assert received_arguments?(1,2,"hola")
      assert_false received_arguments?
      
      assert %w( ant bear cat ).any? ^ nil # ^ is xor:  t ^ f => TRUE
      assert [].any? ^  "block" #                       f ^ t => TRUE
      assert_false %w( ant bear cat ).any? ^ "block" #  t ^ t => FALSE

    end

    
  end

  context "Range" do
    should "include?:: Check if an item belongs to a range or an array" do
      assert((1..100).include?(79))
      assert([1,50,79,100].include?(79))
    end
  end

  context "Set" do
    # #A set is a collection ov values without duplicates. The elements have no
    # order. A hash is a set of k/v pairs.

    should "to_set:: Creating Any Enumerable can be converted to a Set" do
      assert_equal Set[5,1,2,3,4], (1..5).to_set
      assert_equal Set[1,2,5], [1,2,5].to_set
      assert_equal Set[1,2,5], Set.new([1,2,5])
      assert_equal Set[2,3,4], Set.new([1,2,3]) { |x| x+1 }
    end

    should "&:: ^:: |:: -:: <<:: Set Operations" do
      primes = Set[2,3,5,7]
      odds = Set[1,3,5,7,9]

      assert_equal Set[5,7,3], primes & odds, "Intersection"
      assert_equal Set[5,7,3,1,2,9], primes | odds, "Union"
      assert_equal Set[2], primes - odds, "Difference"
      assert_equal Set[1,2,9], primes ^ odds, "Mutual Exclusion: (a|b) - (a&b) "

      assert_equal Set[2,3,5,7,11], primes << 11, "Add item"
    end
  end

  context "Object" do
    should "blank?::" do
      # object is blank if it’s false, empty, or a whitespace string. This
      # simplifies: if !address.nil? && !address.empty? to: if !address.blank?
      assert ''.blank?
      assert ' '.blank?
      assert "".blank?
      assert " ".blank?
      assert [].blank?
      assert nil.blank?
      assert(({}).blank?)
      assert Hash[].blank?
    end

    should "respond_to?:: obj.respond_to?(symbol, include_private=false) => true or false" do
      # Returns true if obj responds to the given method.
      assert_false 3.respond_to?(:upcase)
      assert "hola".respond_to?(:upcase)
    end

    should "send:: obj.send(symbol [, args...]) => obj" do
      # Invokes the method identified by symbol, passing it any arguments
      # specified.
      assert_equal 4, 3.send(:succ)

      #  Send bypasses method visibility constraints, it can invoke private and protected methods.
      class A
        def private_abada; 3; end
        private :private_abada
      end
      a = A.new
      assert_raise NoMethodError do
        a.private_abada
      end
      assert_equal 3, a.send(:private_abada), "Bypassing visibility rules"
    end

  end

  context "ActiveSupport" do
    should "extract_options!::" do
      # Removes and returns the last element in the array if it’s a hash,
      # otherwise returns a blank hash {}
      def show_options(*args)
        args.extract_options!
      end
      assert_equal({}, show_options(1,2))
      assert_equal({:a => :b}, show_options(1,2,:a => :b))
    end
  end

  context "rake actions" do
    should "generate a controller" do
      # ruby script/generate haml_controller Posts open debit credit close

      "" # ruby script/generate haml_controller 'admin/credit_cards' suspend late_fee
    end
    should "generate a migration" do
      # ruby script/generate migration CreatePost ruby script/generate migration
      # AddTitleBodyToPost title:string body:text published:boolean
    end
    should "generate a model" do
      # ruby script/generate model Account ruby script/generate model post
      # title:string body:text published:boolean
    end
    should "generate a scaffold" do
      # ruby script/generate scaffold post title:string body:text
      # published:boolean
    end
    should "destroy something generated" do
      # ruby script/destroy controller Posts ruby script/destroy migration
      # CreatePost
      #
      # ruby script/destroy model Account
    end
  end

  context "Symbols" do
    # Symbols are inmutable strings, which means they can't be change, they must
    # be overwritten.
    should "convert symbols to strings and viceversa" do
      assert_equal "hola", :hola.to_s
      assert_equal :hola, "hola".intern
      assert_equal :hola, "hola".to_sym
      assert_equal :"hola guey", %s[hola guey]
    end

    should "Symbols should not change" do
      assert_equal "berimbau e atabaque", "berimbau" << " e atabaque"
      assert_raise NoMethodError do
        :berimbau << :" e atabaque" # Can't append a symbol
      end
    end

    should "Symbols are more memory efficient than strings" do
      assert_not_equal "hola".object_id, "hola".object_id, "Two objects in memory"
      assert_equal :hola.object_id, :hola.object_id
    end

    should "Always use simbols if you can" do
      assert 5.respond_to?("to_f"), "Ruby is casting it to a symbol, why waste memory?"
      assert 5.respond_to?(:to_f), "Better"
    end
  end

  context "Numeric" do
    #          "Numeric"
    #     "Integer"      "Float"
    # "Fixnum"   "Bignum"
    #
    should "You can separate thousands with underscores" do
      assert_equal 1_000_000, 1000000
    end
  end

  context "Reflections & Bindings" do
    setup do
      class Demo
        def initialize(n)
          @secret = n
        end
        def get_binding
          return binding()
        end
      end
    end
    should "eval::" do
      # eval evaluates a ruby string
      assert_equal 7, eval("3 + 4")

      eval "def multiply(x,y); x*y; end"
      assert_equal 28, multiply(7,4)
    end
    should "eval can receive a binding to set the context" do
      # Bindings store the execution context at some particular place in the
      # code.
      demo = Demo.new(99)
      assert_equal 99, eval("@secret", demo.get_binding)
    end
    should "eval can receive a proc to set the context" do
      #      greeter = Proc.new { |greetings| greetings.map { |greeting| "#{greeting} #{name}"}}
      #      eval( "name = 'pastinha'", greeter)
      #      assert_equal ['oi pastinha', 'aloha pastinha'], greeter.call(['oi', 'aloha'])
    end

    should "instance_eval::" do
      # This method works in the context of the object
      class Klass
        :attr_accessor
        def initialize
          @secret = 99
        end
      end
      k = Klass.new
      assert_equal 99, k.instance_eval { @secret }
      assert_raise NoMethodError do
        k.secret #there is no accessor for that variable
      end
    end

    should "instance_eval:: use it to define singleton methods" do
      Fixnum.instance_eval "def zero; 0; end"
      assert_equal 0, Fixnum.zero

      # You can also pass a block
      Fixnum.instance_eval do
        def ten; 10; end
      end
      assert_equal 10, Fixnum.ten
    end

    should "class_eval:: include?:: mod.class_eval(string [, filename [, lineno]]) => obj" do
      # filename and lineno set the text for error messages Evaluates a string
      # or block in the context of the receiver
      assert_equal 1, Demo.class_eval{ @@x = 1 }
      assert_equal 1, Demo.class_eval{ @@x }

      # You can define instance methods
      Fixnum.class_eval { def number; self; end }
      assert_equal 5, 5.number
      # You can dinamically use private methods
      module M; end
      assert_raise NoMethodError do
        String.include M # include is a private method
      end
      assert_nothing_raised do
        String.class_eval { include M }
      end
      assert String.include?(M)
    end
  end

  context "Introspection" do
    should "is_a?:: kind_of?:: ===:: know its type" do
      assert 5.is_a?(Integer)
      assert 5.kind_of?(Integer)
      assert Integer === 5

      assert_false 5 === Integer
    end

    should "check whether a module includes another" do
      module M1 ; end
      module M2 ; include M1 ; end
      assert M2.include?(M1)
    end

    should "An object or class should know its public and private methods" do
      assert 5.respond_to?(:"+"), "Public"
      assert Fixnum.respond_to?(:include, true), "Private"
      
      assert_false Fixnum.respond_to?(:include), "Private"
    end

    should "A class should know its ancestors::" do
      assert_contains Fixnum.ancestors, Integer
    end

    should "A class should know what modules has included" do
      assert_contains Fixnum.included_modules, Kernel
    end

    should "An object should find all its methods" do
      assert_contains 5.methods, "+"
    end

    should "A class should know its public, private and singleton methods" do
      assert_contains String.public_instance_methods, "upcase!"
      assert String.public_method_defined?(:upcase!)

      assert_contains String.private_instance_methods, "initialize"
      assert_contains String.singleton_methods, "method_added"
    end

    should "An object should know its instance variables, public, private methods" do
      d = Date.new
      assert_contains d.instance_variables, "@of"
      assert d.instance_variable_defined?(:@of)

      assert_equal 0, d.instance_variable_get(:@of) #remember to send text, not the variable

      assert_contains d.public_methods, "between?"
      assert_does_not_contain d.public_methods(false), "between?", "Exclude inherited methods"
      assert_contains d.private_methods, "lambda"
      assert_equal [], d.singleton_methods
    end

  end
end
 


class ViewsTest < ActionView::TestCase
  context "Helpers" do
    should "content_for::" do
      # Calling content_for stores a block of markup in an identifier for later
      # use. You can make subsequent calls to the stored content in other
      # templates or the layout by passing the identifier as an argument to
      # yield.
      content_for :name do
        3
      end
      assert_equal "3", @content_for_name
    end

    should "javascript_include_tag(*sources)::" do
      # Returns an HTML script tag for each of the sources provided. You can
      # pass 1-the filename (w or w/o ext), 2-the full path (relative to your
      # document root). You can modify the html attrs of the SCRIPT tag by
      # passing a hash as the last argument.

      assert_dom_equal('<script type="text/javascript" src="/javascripts/xmlhr.js"></script>',
        javascript_include_tag("xmlhr"), "No extension")
    end

    should "content_tag::content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)" do
      # Returns an HTML block tag of type name surrounding the content. Instead
      # of passing the content as an argument, you can also use a block in which
      # case, you pass your options as the second parameter
      assert_equal '<div class="strong"><p>Hello world!</p></div>',
          content_tag(:div, content_tag(:p, "Hello world!"), :class => "strong")
      active_item = true
      assert_equal '<div class="active">Hello World</div>',
          content_tag(:div, "Hello World", :class => ("active" if active_item ))
    end

 
  end
end