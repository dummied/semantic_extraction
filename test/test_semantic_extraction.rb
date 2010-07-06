require 'helper'
require 'our_extractor'
require 'api_extractor'

class TestSemanticExtraction < Test::Unit::TestCase
  should "correctly identify a url in is_url?" do
    assert_equal SemanticExtraction.is_url?("http://www.indystar.com"), true
    assert_equal SemanticExtraction.is_url?("I am a cheeky monkey"), false
  end
  
  should "throw error when trying to set an invalid extractor" do
    begin
      SemanticExtraction.preferred_extractor = "bullshit"
    rescue StandardError => err
      assert_equal err.class.to_s, "SemanticExtraction::NotSupportedExtractor"
    end
  end
  
  should "be able to define new extractors without api keys" do
    SemanticExtraction.preferred_extractor = "our_extractor"
    assert_equal true, SemanticExtraction.is_valid?(:find_keywords)
  end
  
  should "be able to define new extractors with api keys" do
    SemanticExtraction.preferred_extractor = "api_extractor"
    assert_equal true, SemanticExtraction.requires_api_key.include?("api_extractor")
    assert_equal true, SemanticExtraction.is_valid?(:find_keywords)
  end
  
end
