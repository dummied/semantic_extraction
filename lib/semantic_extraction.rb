require 'ruby_tubesday'
require 'nokogiri'
require 'extlib'
require 'ostruct'

module SemanticExtraction
  
  # We'll automatically require any extractors in the ./semantic_extraction/extractors directory.
  # And, yes, I know there has to be a better way to handle this. Let me know before I get fed up and Google furiously.  
  Dir.entries("./semantic_extraction/extractors").each_with_index do |p, index|
    unless [0,1].include? index
      require "./semantic_extraction/extractors/" + p.sub(".rb", "")
    end
  end
  
  # Thrown when you're lacking an api key for the particular api you're using.
  class MissingApiKey < StandardError; end
  
  # Thrown when the api you're using doesn't support the method you're attempting.
  # This will become more important when we start mapping out all of the other features in the Alchemy API
  class NotSupportedExtraction < StandardError; end
  
  # By default, we assume you want to use Alchemy.
  # To override, just set SemanticExtraction::PREFERRED_EXTRACTOR somewhere.
  def self.preferred_extractor
    defined?(PREFERRED_EXTRACTOR) ? PREFERRED_EXTRACTOR : "alchemy"
  end
  
  HTTP = RubyTubesday.new
  
  # Will return an array of keywords gleaned from the text you pass in.
  # Both Yahoo and Alchemy will handle a block of text, but Alchemy can also handle a plain URL.  
  def self.find_keywords(text)
    klass = SemanticExtraction.const_get(self.preferred_extractor.capitalize)
    if klass.respond_to?(:find_keywords) && defined?(self.preferred_extractor.upcase + "_API_KEY")
      return klass.find_keywords(text)
    elsif !klass.respond_to?(:find_keywords)
      raise NotSupportedExtraction
    else
      raise MissingApiKey
    end
  end
  
  # Will return an array of OpenStruct representing the named entities from the text.
  # At the moment, Alchemy is the only one to support this.
  # Down the road, we'll add in OpenCalais and others.
  def self.find_entities(text)
    klass = SemanticExtraction.const_get(self.preferred_extractor.capitalize)
    if klass.respond_to?(:find_entities) && defined?(self.preferred_extractor.upcase + "_API_Key")
      return klass.find_entities(text)
    elsif !klass.respond_to?(:find_entities)
      raise NotSupportedExtraction
    else
      raise MissingApiKey
    end
  end
  
  # Posts the url to the API.
  def self.post(url, target, calling_param, api_key, api_param="apikey".to_sym)
    HTTP.post(url, :params => {calling_param => target, api_param => api_key} )
  end
  
  # Checks to see if a string is a URL.
  # This is really dumb at the moment, and will likely be refactored in future releases.
  def self.is_url?(link)
    if link[0..3] == "http"
      return true
    else
      return false
    end
  end
  
end