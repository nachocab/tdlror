require 'test_helper'

class HashTest < ActiveSupport::TestCase
  #
  
  #
  context "Hash:" do
    setup do
      @vehicles_hash = { :cars => 36, :boats => 8, :trains => 12, :planes => 21 }
    end

    should "initialize::" do
      # Hash doesn't use an initialize method like Array does
      class SubHashWrong < Hash
        def initialize(arg)
          super
        end
      end

      empty_hash = {}
      assert_equal empty_hash, SubHashWrong.new(:a => 3)

      class SubHashRight < Hash
        def initialize(args = nil)
          super()
          update(args)
        end
      end
      assert_equal Hash[:a => 3], SubHashRight.new(:a => 3)
    end

    should "[]::" do
      # convert even arguments to hash
      hash = Hash['a',2,'b',4]
      assert_equal( {'a' => 2, 'b' => 4}, hash )
    end

    should "hash#delete_if" do
      hash = { :a => 3 , :b => 5, :c => ""}
      hash.delete_if { |key, value| value.blank? }
      assert_equal Hash[:a => 3 , :b => 5], hash

      #if you don't want to modify the original
      hash = { :a => 3 , :b => 5, :c => ""}
      aux = hash.clone.delete_if { |key, value| value.blank? }
      assert_equal Hash[:a => 3 , :b => 5], aux
    end
    should "select::" do
      #   Returns a new ARRAY consisting of [key,value] pairs for which the block returns
      #   true
      vehicles_array = [[:cars, 36], [:planes, 21]]
      assert_same_elements vehicles_array, @vehicles_hash.select { |key, value| value > 20 }
    end

    should "values_at::" do
      #   Return an array containing the values associated with the given keys
      assert_equal [36, 8], @vehicles_hash.values_at(:cars, :boats)
    end

    should "merge!:: AKA update::" do
      #   merges the right into the left.
      h1 = { :a => 100, :b => 200 }
      h2 = { :b => 300, :c => 400 }
      h3 = h1.merge(h2)
      assert_equal Hash[ :a => 100, :b => 300, :c => 400 ], h3


    end

    should "first:: last::" do
      #   Neither array nor hash have .next
      array = []
      hash = {}
      assert array.respond_to?(:first), "Array responds to first"
      assert array.respond_to?(:last), "Array responds to last"
      assert_false hash.respond_to?(:first), "Hash doesn't respond to first"
      assert_false hash.respond_to?(:last), "Hash doesn't respond to last"
    end

    should "reverse_merge::" do
      #   Merges the left into the right
      h1 = {:a => 'max', :b => 'average'}
      h2 = {:b => 'regular', :c => 'min'}
      h3 = h1.reverse_merge(h2)
      assert_equal Hash[ :a => 'max', :b => 'average', :c => 'min' ], h3

      # Useful if you want to guarantee a default value gets set
      h1 = {:a => 'max'}              # If b isn't present, it will equal 'regular'
      h2 = {:b => 'regular', :c => 'min'}
      h3 = h1.reverse_merge(h2)
      assert_equal Hash[ :a => 'max', :b => 'regular', :c => 'min' ], h3

    end

    should "merge:: update::" do
      #   Adds the contents of other_hash to hsh. If no block is specified entries with
      #   duplicate keys are overwritten with the values from other_hash, otherwise the
      #   value of each duplicate key is determined by calling the block with the key, its
      #   value in hsh and its value in other_hash.
    end

    should "Hash#delete:: deletes and returns the value matching the key" do
      h1 = { :a => 100, :b => 200 }
      assert_equal 100, h1.delete(:a)
      assert_equal Hash[:b => 200], h1
    end

    should "shift::" do
      #   removes a key-value pair from the hash and returns it as a two-item array (or
      #   the hash's default value, if it's empty)
      h = { 1 => 'a', 2 => 'b', 3 => 'c'}
      item = h.shift
      assert_equal [1,'a'], item
      assert_equal(({2 => 'b', 3 => 'c'}), h)
    end

    should "symbolize_keys:: also called to_options:: " do
      #   Return a new hash with all keys converted to symbols.
      foo = { 'name' => 'Gavin', 'wife' => :Lisa }
      assert_equal(({ :name => 'Gavin', :wife => :Lisa }), foo.symbolize_keys)
    end

    should "stringify_keys::" do
      #   Return a new hash with all keys converted to strings.
      foo = { :name => 'Gavin', :wife => :Lisa }
      assert_equal(({ 'name' => 'Gavin', 'wife' => :Lisa }), foo.stringify_keys)

    end

    should "diff::" do
      #   creates a hash with key/value pairs that are in one hash but not in the other
      a = {:a => :b, :c => :d}
      b = {:e => :f, :c => :d}
      assert_equal( ({:e => :f, :a => :b}), a.diff(b))
    end

    should "assert_valid_keys::" do
      #   raises an ArgumentError if the hash contains keys not in the argument list. Used
      #   to ensure only valid options are provided to a keyword-argument-based function
    end

    should "slice:: except::" do
      #   slice returns a new hash with only the keys specified.
      #   except returns a new hash without the specified keys
      options = {:a => 3, :b => 4, :c => 5}
      
      assert_equal Hash[:c => 5, :a => 3], options.slice(:a,:c)

      assert_equal Hash[:c => 5, :b => 4], options.except(:a)
    end

    should "dup:: variable assignment" do
      #   Produces a shallow copy of obj (the instance variables of obj are copied, but
      #   not the objects they reference).
      original = { :a => 1, :b => 2 }
      dupped = original.dup # original will not be modified by operations on dupped
      second_dupped = dupped
      second_dupped.delete(:a) # also deletes in dupped

      assert_same_elements( {:b => 2}, second_dupped, "second_dupped" )
      assert_same_elements( {:b => 2 }, dupped, "dupped" )
      assert_same_elements( {:a => 1, :b => 2 }, original, "original" )

      empty_original = {}
      empty_dupped = empty_original.dup
      second_empty_dupped = empty_dupped
      second_empty_dupped[:b] = 2 # also inserts in empty_dupped

      assert_same_elements( {:b => 2}, second_empty_dupped, "second_empty_dupped" )
      assert_same_elements( {:b => 2 }, empty_dupped, "empty_dupped" )
      assert_same_elements( {}, empty_original, "empty_original" )
    end

    should "collect::" do
      #   converts the hash to an array
      hash = {:a => 1, :b => 2}
      assert_same_elements [[:a,1], [:b,2]], hash.collect { |pair| pair }
      assert_same_elements [[:a,1], [:b,2]], hash.collect { |key, value| [key,value] }

      converted_array = *hash
      assert_same_elements [[:a,1], [:b,2]], converted_array
    end

    should "Hash#sort::" do
      # converts the hash into an array of two-element arrays and calls
      # Array#sort::
      hash = { :a => 5, :b => 3}
      assert_equal [[:b,3],[:a,5]], hash.sort { |first, second| first[1] <=> second[1] } # first == [:a,3]


      #   When called without a block, it sorts by keys.
      hash = { 'a' => 5, 'b' => 3}
      assert_equal [['a',5],['b',3]], hash.sort

      hash = { :a => 3, :b => 5}
      assert_raise NoMethodError do
        hash.sort # undefined method <=> for symbol
      end
    end
  end

end