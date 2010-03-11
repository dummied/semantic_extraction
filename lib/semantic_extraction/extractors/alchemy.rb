module SemanticExtraction
  class Alchemy
    STARTER = "http://access.alchemyapi.com/calls/"
        
    def self.find_keywords(text)
      prefix = (SemanticExtraction.is_url?(text) ? "url" : "text")
      endpoint = (prefix == "url" ? "URL" : "Text") + "GetKeywords"
      url = STARTER + prefix + "/" + endpoint
      raw = SemanticExtraction.post(url, text, prefix, SemanticExtraction::ALCHEMY_API_KEY)
      h = Nokogiri::XML(raw)
      if (h/"keywords keyword")
        keywords = []
        (h/"keywords keyword").each do |p|
          keywords << p.text
        end
      end
      return keywords
    end
    
    def self.find_entities(text)
      prefix = (SemanticExtraction.is_url?(text) ? "url" : "text")
      endpoint = (prefix == "url" ? "URL" : "Text") + "GetRankedNamedEntities"
      url = STARTER + prefix + "/" + endpoint
      raw = SemanticExtraction.post(url, text, prefix, SemanticExtraction::ALCHEMY_API_KEY)
      h = Nokogiri::XML(raw)
      if (h/"entities entity")
        entities = []
        (h/"entities entity").each do |p|
          hashie = Hash.from_xml(p.to_s)["entity"]
          typer = hashie.delete("type")
          if typer
            hashie["entity_type"] = typer
          end
          entities << OpenStruct.new(hashie)
        end
      end
      return entities
    end

  end
end