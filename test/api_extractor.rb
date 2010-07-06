module SemanticExtraction
  module ApiExtractor
    include SemanticExtraction::UtilityMethods
    
    SemanticExtraction.valid_extractors << "api_extractor"
    SemanticExtraction.requires_api_key << "api_extractor"
    
    SemanticExtraction.module_eval("mattr_accessor :api_extractor_api_key")
    
    SemanticExtraction.api_extractor_api_key = "bogus"
    
    def self.find_keywords(text)
      return []
    end
      
  end
end