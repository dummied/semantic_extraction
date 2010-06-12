module SemanticExtraction
  module Yahoo
    include SemanticExtraction::UtilityMethods
    STARTER = "http://api.search.yahoo.com/ContentAnalysisService/V1/termExtraction"
      
    def self.find_keywords(text)
      prefix = 'context'
      raw = SemanticExtraction.post(STARTER, text, prefix, :appid)
      self.output_keywords(raw)
    end
  
    def self.output_keywords(raw)
      h = Nokogiri::XML(raw)
      keywords = []
      (h/"Result").each do |p|
        keywords << p.text
      end
      return keywords
    end

  end
end