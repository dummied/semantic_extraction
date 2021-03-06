require 'ruby_tubesday'
require 'nokogiri'
require 'ostruct'

module SemanticExtraction
  
  class << self
    attr_reader :valid_extractors
    attr_writer :valid_extractors
    
    attr_reader :requires_api_key
    attr_writer :requires_api_key
    
    attr_reader :yahoo_api_key
    attr_writer :yahoo_api_key
    
    attr_reader :alchemy_api_key
    attr_writer :alchemy_api_key
    
    attr_reader :preferred_extractor
  end
  
  self.valid_extractors = ["yahoo", "alchemy"]
  
  self.requires_api_key = ["yahoo", "alchemy"]
  
  # By default, we assume you want to use Alchemy.
  # To override, just set SemanticExtraction.preferred_extractor somewhere and define the appropriate api_key.
  def self.preferred_extractor=(value)
    if self.valid_extractors.include?(value)
      @preferred_extractor = value
    else
      raise NotSupportedExtractor
    end
  end 
  
  self.preferred_extractor = "alchemy"

    
  # Screw it. Hard-code time!
  require 'semantic_extraction/utility_methods'
  require 'semantic_extraction/extractors/yahoo'
  require 'semantic_extraction/extractors/alchemy'
  
  # Thrown when you're lacking an api key for the particular api you're using.
  class MissingApiKey < StandardError; end
  
  # Thrown when the api you're using doesn't support the method you're attempting.
  # This will become more important when we start mapping out all of the other features in the Alchemy API
  class NotSupportedExtraction < StandardError; end
  
  # Thrown when you attempt to set the preferred extractor to an extractor we don't yet support.
  class NotSupportedExtractor < StandardError; end
  
  def self.find_generic(typer, args)
    if self.is_valid?(typer)
      return @@klass.send(typer.to_sym, args)
    elsif !@@klass.respond_to?(typer.to_sym)
      raise NotSupportedExtraction
    else
      raise MissingApiKey
    end
  end
  
  def self.method_missing(method, args)
    find_generic(method.to_sym, args)
  end
  
  
  def self.is_valid?(method)
    @@klass = SemanticExtraction.const_get(self.preferred_extractor.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase })
    if self.requires_api_key.include? self.preferred_extractor
      (@@klass.respond_to?(method) && defined?(self.send((preferred_extractor + "_api_key").to_sym)) && !(self.send((preferred_extractor + "_api_key").to_sym)).empty?) ? true : false
    else
      @@klass.respond_to?(method)
    end
  end
  
end