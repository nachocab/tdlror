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

    should "length::" do
      assert_not_equal 3, "así".length
      assert_equal 3, "así".mb_chars.length
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
end
 


