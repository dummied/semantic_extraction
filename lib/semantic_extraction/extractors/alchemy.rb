module SemanticExtraction
  module Alchemy
    include SemanticExtraction::UtilityMethods
    STARTER = "http://access.alchemyapi.com/calls/"
        
    def self.find_keywords(text)
      prefix = is_url?(text) ? "url" : "text"
      endpoint = (prefix == "url" ? "URL" : "Text") + "GetKeywords"
      url = STARTER + prefix + "/" + endpoint
      raw = post(url, text, prefix)
      output_keywords(raw)
    end
    
    def self.output_keywords(raw)
      h = Nokogiri::XML(raw)
      keywords = []
      (h/"keywords keyword").each do |p|
        keywords << p.text
      end
      return keywords
    end
    
    def self.find_entities(text)
      prefix = is_url?(text) ? "url" : "text"
      endpoint = (prefix == "url" ? "URL" : "Text") + "GetRankedNamedEntities"
      url = STARTER + prefix + "/" + endpoint
      raw = post(url, text, prefix)
      output_entities(raw)
    end
    
    def self.output_entities(raw)
      h = Nokogiri::XML(raw)
      entities = []
      (h/"entities entity").each do |p|
        hashie = Hash.from_xml(p.to_s)["entity"]
        typer = hashie.delete("type")
        if typer
          hashie["entity_type"] = typer
        end
        entities << OpenStruct.new(hashie)
      end
      return entities
    end
    
    def self.extract_text(text)
      prefix = is_url?(text) ? "url" : "html"
      endpoint = (prefix == "url" ? "URL" : "HTML") + "GetText"
      url = STARTER + prefix + "/" + endpoint
      raw = post(url, text, prefix)
      output_text(raw)
    end
    
    def self.output_text(raw)
      h = Nokogiri::XML(raw)
      return (h/"text").first.inner_html
    end
  end
end