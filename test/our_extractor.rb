module SemanticExtraction
  module OurExtractor
    include SemanticExtraction::UtilityMethods
    
    SemanticExtraction.valid_extractors << "our_extractor"
    
    def self.find_keywords(text)
      return []
    end
      
  end
end