require 'test_helper'
require 'action_view/helpers'

# Use include to add modules

class LearningTest < ActiveSupport::TestCase
  context "Metaprogramming" do 
    should "alias" do
      # nofunciona (¿?)
#      class Hash
#        alias :old_select :select
#        def select(&block)
#          a = old_select(&block)
#          Hash[*a.flatten]
#        end
#      end
#
#      capoeira = {:angola => 1904, :regional => 1998}
#      results = { :regional => 1998 }
#      assert_equal results, capoeira.select { |style, year| year > 1950 }
    end
  end
end
