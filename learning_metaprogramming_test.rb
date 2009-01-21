require 'test_helper'

# Use include to add modules

class LearningMetaprogramming < ActiveSupport::TestCase
  #
  #
  context "Metaprogramming" do 
    should "alias" do
      # nofunciona (¿?)
      #            class Hash
      #              alias :old_select :select
      #              def select(&block)
      #                a = old_select(&block)
      #                Hash[*a.flatten]
      #              end
      #            end
      #
      #            capoeira = {:angola => 1904, :regional => 1998}
      #            results = { :regional => 1998 }
      #            assert_equal results, capoeira.select { |style, year| year > 1950 }
#      Fixnum.class_eval do
#      alias original_to_s to_s
#        def to_s
#          self.to_s << " as a string"
#        end
#      end
#      assert_equal "5 as a string", 5.to_s
    end
  end
end
