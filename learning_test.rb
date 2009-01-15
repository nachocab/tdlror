require 'test_helper'

class LearningTest < ActiveSupport::TestCase
  # Glossary
  #
  # first-class entities - They can be stored in variables, they are objects,
  # they can be created with .new()
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

    should "Array literals" do
      # No interpolation %w
      assert_equal ['a', 'b', 'c'], %w[a b c]
      assert_equal ['(', '[', '{', '<'], %w| ( [ { < |
      assert_equal ['\s'], %w(\s)

      # Interpolation %W
      assert_equal [' '], %W(\s)
      assert_equal ["\s"], %W(\s)
    end
  end
  context "Blocks & Procs" do
    # Blocks are NOT first-class entities.
    should "Can't assign a block to a variable" do
      # my_block = { |x| x*x }
    end
    
    should "We can yield to a block inside a method" do
      # The value of the "assert" is the value of the expression in the block
      # (x>3), using "number" as a parameter for x.

      def send_a_number(number) # "send_a_number" is the function, "number" is the argument of the function
        # The presence of yield means a block has to be passed to the function.
        yield(number) ? true : false # "number" is the argument of the yield, it will become the argument of the block
      end

      assert send_a_number(4) { |x| x > 3} 
      assert !send_a_number(2) { |x| x > 3}
    end

    # Procs are objects. They can be assigned to variables.
    should "&=: The unary ampersand operator converts Blocks into Procs and viceversa" do
      def convert_block_to_proc(&block)# The unary ampersand operator
        block
      end
      
      external_proc = convert_block_to_proc { |x|  x > 3 }

      assert external_proc.call(4)
      assert !external_proc.call(1)

      assert_raise ArgumentError do
        [1,4,7].any?(external_proc) # any? expects a block
      end
      
      assert [1,4,7].any?(&external_proc), "We turn the proc back into a block"

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
    should "each=:" do
      #      (5..10).each
    end

    should "any?=: enum.any? [{|obj| block } ] => true or false" do
      # Passes each element of the collection to the given block and it returns
      # TRUE if at least ONE of the collection members is not false or nil. It
      # expects a block
      assert %w{ ant bear cat }.any? {|word| word.length >= 3} # false true false => TRUE

    end

    should "inject=: 1st syntax: enum.inject(initial) {| memo, obj | block } => obj" do
      # #Combines the elements of enum by applying the block to an #accumulator
      # value (memo) and each element in turn. At each step, #memo is set to the
      # value returned by the block. The first form lets #you supply an initial
      # value for memo. The second form uses the first #element of the
      # collection as a the initial value (and skips that element #while
      # iterating).
      (5..10)
    end

    should "inject=: 2nd syntax: enum.inject {| memo, obj | block } => obj" do

    end
  end
end
