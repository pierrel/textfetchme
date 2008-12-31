require 'overrides'

class OverridesTest < Test::Unit::TestCase
  def test_first_word
    assert_equal("This", "This is a sentence".first_word)
    
    assert_equal("Superman", "Superman".first_word)
    
    assert_equal("crazy-wazy", "crazy-wazy man".first_word)
  end
  
  def test_divide
    assert_equal(["Thes", "e ar", "e th", "e wo", "rds"], "These are the words".divide(4))
  end
end