require 'test_helper'

# Use include to add modules

class RubyExperimentTest < ActiveSupport::TestCase

  context "Regexp and Unicode UTF" do
    setup do 
      $KCODE = 'UTF8'
    end
    # Methods with UTF-8 issues:
    # == eql?
    #  [] []=
    #   gsub gsub! sub sub! tr tr!
    #     index length  size
    #       lstrip lstrip! rindex rstrip rstrip! strip strip!
    #        scan match =~
    #         slice slice!
    #         reverse
    #           downcase capitalize

    should "String#[]::" do
      # If a Regexp is supplied, the matching portion of str is returned.

      str = "hello there"
      assert_equal "e", str[/[aeiou]/]
      assert_equal "ello", str[/[aeiou].{3}/]

      # If a numeric parameter follows the regular expression, that component of the
      # MatchData is returned instead.
      assert_equal "ell", str[/([aeiou])(.)(.)/] #=> groups: 0[ell] 1[e] 2[l] 3[l]
      assert_equal "ell", str[/([aeiou])(.)(.)/, 0]
      assert_equal "e", str[/([aeiou])(.)(.)/, 1]
      assert_equal "l", str[/([aeiou])(.)(.)/, 2]
      assert_equal "l", str[/([aeiou])(.)(.)/, 3]
      #
      # If a String is given, that string is returned if it occurs in str. In both cases,
      # nil is returned if there is no match.
      assert_equal "lo", str["lo"]
    end

    should "Array#pack:: String#unpack::" do
      # Array#pack::   Takes array of NUMBERS and encodes it into a STRING
      #
      #          C: unsigned char
      #
      #          U: UTF-16 (dec)
      
      # String#unpack:: Takes STRING and decodes it into an array of NUMBERS
      #
      #          C: extract a character as an unsigned integer
      #
      #          U: UTF-16 (dec) characters as unsigned integers

      # All of these are equivalent:
      #   "é"                => letter = U+00E9
      #   "\303\251"         => byte (octal)
      #       [195,169]      => decimal
      #          "\xe9"      => UTF-16 (hex)
      #             [233]    => UTF-16 (decimal)
      #

      assert_equal "é", "\303\251",  "Octal" # They can be used interchangeably
      
      # from letter to byte
      #      assert_equal 1, "é".unpack("C*").pack("C*")

      # from letter or byte (octal)::
      assert_equal [195,169],        "é".unpack("C*") # to decimal
      assert_equal [233],            "é".unpack("U*") # to utf-16 (dec)
      assert_equal [233],     "\303\251".unpack("U*") # same thing

      # from decimal
      assert_equal "é",         [195,169].pack("C*")  # to letter

      # from UTF-16 (dec)
      assert_equal "é",             [233].pack("U*") # to letter

      # from UTF-16 (hex)
      assert_equal [233],         "\xe9".unpack("C*")  # to utf-16 (dec)
      assert_equal [233],         "\xe9".unpack("C*")  
      assert_equal   233,         "0xe9".hex
      assert_equal   233,         "0xe9".to_i(16)
    end

    should "Integer#chr:: DON'T USE" do

      #       ERRORS
      assert_equal 195, "é"[0]                   #=> ERROR, only the first byte
      assert_equal 104, ?h                       #=> Don't use for weird chars.
      assert_equal 195, "\303\251"[0]       #=> ERROR, only the first byte
      assert_equal 195, "\303"[0]           #=> Don't use for weird chars.
      assert_equal "h", 0x68.chr    # Don't use for weird chars
      assert_equal "h", 104.chr # Don't use for weird chars
    end

    should "regexp utf-8" do
      assert_equal %w( ñ é ), 'ñé'.scan(/./)
      #            assert_equal %w( ñ é ), 'ñé'.scan(/(?:\303\251|)/)
    end

    should "scan::" do
      # using the char codes \x64-\xe9 DOESN'T WORK. Only using bytes (octal) or the
      # letters
      assert_equal ["jabón"], "jabón".scan(/(?:[a-zà-öø-ÿšœž])+/)
    end

    should "downcase:: " do
      assert_equal "á", "Á".mb_chars.downcase
    end

    should "length:: aka size::" do
      assert_not_equal 3, "así".length
      assert_equal 3, "así".mb_chars.length
    end

    # ActiveSupport::Multibyte::Chars
    should "normalize::" do
      # Unicode Normalization Forms
      # NFD  - (TILDES)               - Canonical Decomposition                              - chars decomposed by canonical equivalence
      # NFC  - (NOTHING)              - Canonical Decomposition     + Canonical Composition
      # NFKD - (LIGATURES AND TILDES) - Compatibility Decomposition                          - chars decomposed by compatibility equivalence
      # NFKC - (LIGATURES)            - Compatibility Decomposition + Canonical Composition
      # Canonical equivalence     - equivalency between characters that represent the
      # same character.Same visual appearance. Ex: ñ == n + ~.
      # Compatibility equivalence - weaker equivalency, they may have different visual
      # appearance. Ex: ﬁ ~~ fi
      # assert_equal "ﬁe´",  "ﬁé".mb_chars.normalize(:d).to_s
      assert_equal "ﬁé",   "ﬁé".mb_chars.normalize(:c).to_s
      # assert_equal "fie´", "ﬁé".mb_chars.normalize(:kd).to_s
      assert_equal "fié",  "ﬁé".mb_chars.normalize(:kc).to_s

      # problem:
      assert_equal "Æ",  "Æ".mb_chars.normalize(:d).to_s
      assert_equal "Æ",   "Æ".mb_chars.normalize(:c).to_s
      assert_equal "Æ", "Æ".mb_chars.normalize(:kd).to_s
      assert_equal "Æ",  "Æ".mb_chars.normalize(:kc).to_s

    end

    should "str.gsub::(pattern,replacement)" do
      #Returns a copy of str with all occurrences of pattern replaced with either
      #replacement or the value of the block. The pattern will typically be a Regexp;
      #if it is a String then no regular expression metacharacters will be interpreted
      #(that is /\d/ will match a digit, but '\d' will match a backslash followed by
      #a 'd').  If a string is used as the replacement, special variables from the
      #match (such as $& and $1) cannot be substituted into it, as substitution into
      #the string occurs before the pattern match starts. However, the sequences \1,
      #\2, and so on may be used to interpolate successive groups in the match.  In
      # block form, the current match string is passed in as a parameter, and variables
      # such as $1, $2, $`, $&, and $' will be set appropriately. The value returned by
      # the block will be substituted for the match on each call.  The result inherits
      #  any tainting in the original string or any supplied replacement string.
      # "hello".gsub(/[aeiou]/, '*')#=> "h*ll*"
      # "hello".gsub(/([aeiou])/, '<\1>')#=> "h<e>ll<o>"
      # "hello".gsub(/./) {|s| s[0].to_s + ' '} #=> "104 101 108 108 111 "
      assert_equal "hl", "hola".gsub(/[oa]/,"")
      assert_equal "hl", "hola".gsub(/[^hl]/,"")
    end
  end

  context "File" do
    should "exist?::" do
      # relative path, starting at root folder.
      assert File.exist? 'empty_file.txt'
    end

    should "gets::" do
      f = 'empty_file.txt'
      words = ""
      File.open(f, "r") do |infile|
        while line = infile.gets
          words << line
        end
      end

      assert_equal '¡Hola João!', words
    end


  end

  context "ways to specify arguments" do
    should "myFunction(*args)" do
      # Ex: myFunction(:argument)
      #   options == {}
      #   args.first == :argument #=> args == [:argument], that's why we use first.
      # Ex: myFunction(:argument, :conditionA => true, :conditionB => false)
      #   options == {:conditionA => true, :conditionB => false}
      #   args.first == :argument
      # The first argument determines what function gets called with the remaining options.

      # Only use extract_options when receiving (*args) or (*args, &block)
      def extract_options! # removes and returns the last element if it's a hash, otherwise returns {}
        last.is_a?(::Hash) ? pop : {}
      end

      VALID_FIND_OPTIONS = [ :conditions, :include, :joins, :limit, :offset,
        :order, :select, :readonly, :group, :from, :lock ]

      def validate_find_options(options) #:nodoc:
        options.assert_valid_keys(VALID_FIND_OPTIONS)
      end

      def assert_valid_keys(*valid_keys)
        unknown_keys = keys - [valid_keys].flatten
        raise(ArgumentError, "Unknown key(s): #{unknown_keys.join(", ")}") unless unknown_keys.empty?
      end

      def find(*args)
        options = args.extract_options!
        validate_find_options(options)

        case args.first
        when :first then find_initial(options)
        when :last  then find_last(options)
        when :all   then find_every(options)
        else             find_from_ids(args, options)
        end
      end

      def find_initial(options)
        options.update(:limit => 1)
        find_every(options).first
      end

      def find_last(options)
        order = options[:order]

        if order
          order = reverse_sql_order(order)
        elsif !scoped?(:find, :order)
          order = "#{table_name}.#{primary_key} DESC"
        end

        find_initial(options.merge({ :order => order }))
      end
    end

    should "myFunction(symbol|{key => value})" do
      # this accepts:
      #  myFunction :ok
      #  myFunction :status => 404
      def myFunction(*args)
        options = args.extract_options!
        status = interpret_status(args.shift || options.delete(:status))
      end
    end

    should "myFunction(symbol)" do
      # If instead of using opts = {} we had used *opts, when opts wasn't specified, it would have become [] which
      #  would make assert_valid_keys fail, because it has to be applied on a hash.
      #   Person.calculate(:count, :all) # The same as Person.count
      #   Person.average(:age) # SELECT AVG(age) FROM people...
      #   Person.minimum(:age, :conditions => ['last_name != ?', 'Drake']) # Selects the minimum age for everyone with a last name other than 'Drake'
      #   Person.minimum(:age, :having => 'min(age) > 17', :group => :last_name) # Selects the minimum age for any family without any minors
      #   Person.sum("2 * age")
      def maximum(column_name, options = {})
        calculate(:max, column_name, options)
      end

      def calculate(operation, column_name, options = {})
        validate_calculation_options(operation, options)
        column_name     = options[:select] if options[:select]
        column_name     = '*' if column_name == :all
        column          = column_for column_name
        catch :invalid_query do
          if options[:group]

          end
        end
      end
    end

    should "myFunction(action = nil, *args):: BAD PRACTICE" do
      # Wanting to do this is a mistake:
      # myFunction('a')
      # myFunction(:unique)
      # myFunction(:used_more_than => 3)
      #
      # much better to simplify it
      # myFunction(*args)
      # myFunction(:starting_with => 'a') + extract_options
      #
      # or do this:
      # myFunction(elem, *args)
      #


    end

  end

end
 


