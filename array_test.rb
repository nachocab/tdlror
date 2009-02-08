require 'test_helper'

class ArrayTest < ActiveSupport::TestCase
  # -
  #     Array difference
  #
  # &
  #     Set intersection
  #
  # *
  #     Repetition
  #
  # [] slice slice!
  #     Element reference
  #
  # []
  #     New Array
  #
  # []=
  #     Element assignment
  #
  # |
  #     Set Union
  #
  # +
  #     Concatenation
  #
  # << push
  #     Append. can be chained with other appends.
  #
  # <=>
  #     Comparison
  #
  # ==
  #     Equality
  #
  # abbrev (NOT VERY USEFUL)
  #     Calculates the set of unambiguous abbreviations for the strings in self
  #
  # all?    (Enumerable)
  #
  #
  # any?    (Enumerable)
  #
  #
  # assoc (USEFUL AND NOT USED)
  #     Searches through an array whose elements are also arrays. Compares ARG
  #     with the first element of each contained array and returns the first
  #     that matches.
  #
  # rassoc (USEFUL AND NOT USED)
  #     Searches through the array whose elements are also arrays. Compares ARG
  #     with the second element of each contained array and returns the
  #     first that matches
  #
  # at
  #     Returns the element at ARG.
  #
  # fetch (NOT VERY USEFUL)
  #     Tries to return the element at position index. Raises errors and
  #     modifies return value. It's an at:: improved.
  #     a.fetch(4) { |i| i*i }   #=> 16
  #
  # clear
  #     Empties array
  #
  # collect map collect! map!
  #
  #     Invokes block once for each element of self. Creates a new array
  #     containing the values returned by the block.
  #
  # compact   compact!
  #     Returns a copy of self with all nil elements removed.
  #
  # concat
  #     Appends the elements in ARG to self.
  #
  # dclone
  #     NOT DOCUMENTED
  #
  # delete
  #     Deletes items from self that are equal to ARG.
  #
  # delete_at
  #     Deletes element at the specified index
  #
  # delete_if
  #     Deletes every element of self for which block evaluates to true.
  #
  # detect    (Enumerable)
  #
  #
  # each
  #     Calls block once for each element in self, passing that element as a parameter
  #
  # each_cons    (Enumerable)
  #
  #
  # each_index
  #     Same as Array#each, but passes the index of the element instead of the element itself.
  #
  # each_slice    (Enumerable)
  #
  #
  # each_with_index    (Enumerable)
  #
  #
  # empty?
  #     Returns true if self array contains no elements.
  #
  # entries    (Enumerable)
  #
  #
  # enum_cons    (Enumerable)
  #
  #
  # enum_slice    (Enumerable)
  #
  #
  # enum_with_index    (Enumerable)
  #
  #
  # eql?
  #     Returns true if array and other are the same object, or are both arrays with the same content
  #
  # fill (USEFUL AND NOT USED)
  #     Set the elements of an array to a value (which can vary).
  #
  # find    (Enumerable)
  #
  #
  # find_all    (Enumerable)
  #
  #
  # first (USEFUL AND NOT USED)
  #     Returns the first or the first ARG elements
  #
  # flatten   flatten!
  #     Returns a one-dimensional array (recursive flattening)
  #
  # frozen?
  #     Return true if this array is frozen
  #
  # grep    (Enumerable)
  #
  #
  # hash
  #     Compute a hash-code for this array
  #
  # include?
  #     Returns true if the given object is present in self
  #
  # index
  #     Returns the index of the first object in self equal to ARG
  #
  # rindex
  #     Returns the index of the last object in self equal to ARG
  #
  # inject    (Enumerable)
  #
  #
  # insert
  #     Inserts values before index
  #
  # inspect
  #     Create a printable version of array.
  #
  # join
  #     Returns a string created by converting each element of the array to a
  #     string, separated by sep.
  #
  # last (USEFUL AND NOT USED)
  #     Returns the last or last n elements
  #
  # length size
  #     Returns the number of elements in self.
  #
  # max    (Enumerable)
  #
  #
  # member?    (Enumerable)
  #
  #
  # min    (Enumerable)
  #
  #
  # new
  #     Creates new instance of array
  #
  # nitems (UNU)
  #     Returns the number of non-nil elements in self
  #
  # pack
  #     Packs the contents of arr into a binary sequence
  #
  # partition    (Enumerable)
  #
  #
  # pop
  #     Removes the last element from self and returns it,
  #
  # pretty_print
  #     NOT_DOC
  #
  # pretty_print_cycle
  #     NOT_DOC
  #
  #
  # quote
  #     NOT_DOC
  #
  #
  # reject   reject!
  #     Returns a new array containing the items in self for which
  #     the block is not true.
  #
  # replace (USEFUL AND NOT USED) initialize_copy
  #     Replaces the contents of self with the contents of array ARG.
  #
  # reverse   reverse!
  #     Returns a new array containing self‘s elements in reverse order.
  #
  # reverse_each (UNU)
  #     Same as Array#each, but traverses self in reverse order.
  #
  #
  # select
  #     Invokes the block passing in successive elements from array, returning
  #     an array containing those elements for which the
  #     block returns a true value
  #
  # shift
  #     Returns the first element of self and removes it
  #
  # unshift
  #     Prepends objects to the front of array.
  #
  # sort   sort!
  #     Returns a new array created by sorting self.
  #
  # sort_by    (Enumerable)
  #
  #
  # to_a
  #     Returns self. If called on a subclass of Array, converts the receiver
  #     to an Array object.
  #
  # to_ary
  #     Returns self.
  #
  # to_s
  #     Returns self.join
  #
  # to_set    (Enumerable)
  #
  #
  # to_yaml
  #     ND
  #
  # transpose
  #     Assumes that self is an array of arrays and transposes the
  #     rows and columns.
  #
  # uniq   uniq!
  #     Returns a new array by removing duplicate values in self.
  #
  #
  # values_at  indexes(DON'T USE) indices(DON'T USE)
  #     Returns an array containing the elements in self corresponding
  #     to the given ARG (indexes)
  #
  # yaml_initialize
  #     ND
  #
  # zip
  #     Converts any arguments to arrays, then merges elements of self with
  #     corresponding elements from each argument
  #

  should "assoc:: rassoc::" do
    #assoc::
    #Searches through an array whose elements are also arrays comparing obj
    #with the first element of each contained array using obj.==. Returns the
    #first contained array that matches (that is, the first associated array),
    #or nil if no match is found. See also Array#rassoc.
    # s1 = [ "colors", "red", "blue", "green" ]
    # s2 = [ "letters", "a", "b", "c" ]
    # s3 = "foo"
    # a  = [ s1, s2, s3 ]
    # a.assoc("letters")  #=> [ "letters", "a", "b", "c" ]
    # a.assoc("foo")      #=> nil
    #
    # rassoc::
    #Searches through the array whose elements are also arrays. Compares key
    #with the second element of each contained array using ==. Returns the first
    #contained array that matches. See also Array#assoc.
    # a = [ [ 1, "one"], [2, "two"], [3, "three"], ["ii", "two"] ]
    # a.rassoc("two")    #=> [2, "two"]
    # a.rassoc("four")   #=> nil
    assert_equal [3,"a"], [[3,"a"],[2,"b"]].rassoc("a")
    assert_equal ["a",3], [["a",3],["b",2]].assoc("a") 
  end

  should "Array#&:: |:: -::" do
    # a & b - Intersection
    # a | b - Union
    # a - b - Difference
    assert_equal [1,2],     [1,2,3] & [1,2,4]
    assert_equal [1,2,3,4], [1,2,3] | [1,2,4]
    assert_equal [3],       [1,2,3] - [1,2]
    # xor a or b, but not both ( (a|b) - (a&b) )
  end

  should "unshift:: shift:: pop:: push::" do
    # unshift & shift - from the front
    # pop & push - from the back
    assert_equal [0,1,2,3], [1,2,3].unshift(0)

    assert_equal [-1,0,1,2,3], [1,2,3].unshift(-1, 0)

    arr = [1,2,3]
    assert_equal 1, arr.shift # take out the first
    assert_equal [2,3], arr
    # can't do arr.shift(2) ??


    arr = [1,2,3]
    assert_equal 3, arr.pop
    assert_equal [1,2], arr

    arr = [1,2,3]
    assert_equal [1,2,3,4], arr.push(4)
  end

  should "creation, Kernel#Array" do
    #   Tries to coerce its arguments into an array
    assert_equal [1,2,3], Array([1,2,3])
    assert_equal [1,2,3], Array(1..3)
    assert_equal [3], Array(3) # Alternative syntax
  end

  should "join:: Convert array to string" do
    assert_equal "a-b-c", %w(a b c).join("-")
    assert_equal "a-b-c", %w(a b c) * "-", "see the splat operator"
    assert_equal "A-B-C", %w(a b c).collect{ |letra| letra.upcase! }.join("-")
  end

  should "to_sentence::" do
    assert_equal "Luis, Juan y Pedro", %w(Luis Juan Pedro).to_sentence(:connector => 'y', :skip_last_comma => true)
  end

  should "in_groups_of::(size, fill_with)" do
    #   Group elements of the array into fixed-size groups
    assert_equal [[1,2,3], [4,5,6], [7,8,nil]], (1..8).to_a.in_groups_of(3)
    assert_equal [[1,2,3], [4,5,6], [7,8,-1]], (1..8).to_a.in_groups_of(3, -1)
  end

  should "split::" do
    #   splits on a value (and removes it) or on the result of a block
    assert_equal [[1,2,3],[5,6,7,8]], (1..8).to_a.split(4)
    assert_equal [[1,2,3],[5,6,7,8]], (1..8).to_a.split { |i| i == 4}
  end

  should "Array#extract_options!::" do
    #   ARRAY => HASH Removes and returns the last element in the array if it’s a hash,
    #   otherwise returns a blank hash {}
    def show_options(*args) #the splat op. wraps all arguments in an ARRAY => price to pay for optional arguments
      assert args.kind_of?(Array)
      opts = args.extract_options! # we have extracted the hash (if there is one) from the array
    end

    hash = {:a => :b}
    assert hash.kind_of?(Hash)

    # args[0] == 1, args[1] == 2
    assert_equal({}, show_options(1,2))

    # args[0] == 1, args[1] == 2, args[2] = {:a => :b}
    assert_equal(hash, show_options(1,2,:a => :b))
  end

  should "Array#<<:: add item" do
    a = []
    assert_equal [2], a << 2
  end

  should "compact::" do
    #   removes nil values
    assert_equal [1,2,3], [1,nil,2,nil,3].compact
  end

  should "count::" do
    ary = [1,10,3,10,4,5]
    #      In ruby 1.8.7
    #      assert_equal 2, ary.count(10) #counts number of elems == to obj.
    #      assert_equal 3, ary.count{|x| x > 4} #counts number of elems that satisfy condition
  end

  should "Array#delete::" do
    arr = [1,2,3,2,4,2]
    assert_equal 2, arr.delete(2)
    assert_equal [1,3,4], arr
  end

  should "Array#sort:: sort_by::" do
    #   Returns a new array created by sorting self. Comparisons for the sort will be
    #   done using the <=> operator or using an optional code block. The block
    #   implements a comparison between a and b, returning -1, 0, or #+1
    arr = [2,4,3,5,1]
    assert_equal [1,2,3,4,5], arr.sort

    assert_equal [5,4,3,2,1], arr.sort { |first, second| second <=> first }

  end

  should "assoc:: rassoc::" do
    #   rassoc:: Compares argument with the second element of each contained array using
    #   ==. Returns the first contained array that matches it. assoc:: same thing, but
    #   the first element.
    arr = [[:a,3], [:b,4], [:c,5]]
    assert_equal [:a,3], arr.assoc(:a)
    assert_equal [:a,3], arr.rassoc(3)
  end

  should "zip::" do
    # array.zip(ARG, ...)                   -> an_array
    # array.zip(ARG, ...) {| arr | block }  -> nil
    #      Converts args to arrays and merges elements of self with corresponding
    #      elements from each argument.
    #      This generates a sequence of (self.size)-element arrays,
    #        where n is one more that the count of arguments. If the size of any argument is less
    #      than enumObj.size, nil values are supplied. If a block given, it is invoked for each output
    #        array, otherwise an array of arrays is returned.
    a = [ 4, 5, 6 ]
    b = [ 7, 8, 9 ]

    assert_equal [[1, 4, 7], [2, 5, 8], [3, 6, 9]], [1,2,3].zip(a, b)
    assert_equal [[1, 4, 7], [2, 5, 8]], [1,2].zip(a,b)
    assert_equal [[4,1,8], [5,2,nil], [6,nil,nil]], a.zip([1,2],[8])
  end
end