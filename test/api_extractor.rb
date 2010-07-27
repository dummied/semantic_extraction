module SemanticExtraction
  module ApiExtractor
    include SemanticExtraction::UtilityMethods
    
    SemanticExtraction.valid_extractors << "api_extractor"
    SemanticExtraction.requires_api_key << "api_extractor"
    
    SemanticExtraction.module_eval("class << self; attr_reader :api_extractor_api_key end")
    SemanticExtraction.module_eval("class << self; attr_writer :api_extractor_api_key end")
    
    SemanticExtraction.api_extractor_api_key = "bogus"
    
    def self.find_keywords(text)
      return []
    end
      
  end
end