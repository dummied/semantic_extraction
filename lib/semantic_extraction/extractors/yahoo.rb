module SemanticExtraction
  class Yahoo
    STARTER = "http://api.search.yahoo.com/ContentAnalysisService/V1/termExtraction"
        
    def self.find_keywords(text)
      prefix = 'context'
      raw = SemanticExtraction.post(STARTER, text, prefix, SemanticExtraction::YAHOO_API_KEY, :appid)
      h = Nokogiri::XML(raw)
      if (h/"Result")
        keywords = []
        (h/"Result").each do |p|
          keywords << p.text
        end
      end
      return keywords
    end

  end
end