require 'ruby_tubesday'
require 'nokogiri'
require 'extlib'
require 'ostruct'
require 'active_support/core_ext/module/attribute_accessors'

module SemanticExtraction
  
  # By default, we assume you want to use Alchemy.
  # To override, just set SemanticExtraction.preferred_extractor somewhere and define the appropriate api_key.
  mattr_accessor :preferred_extractor
  mattr_accessor :alchemy_api_key
  mattr_accessor :yahoo_api_key
  mattr_accessor :valid_extractors
  
  self.valid_extractors = ["yahoo", "alchemy"]
  
  def self.preferred_extractor=(value)
    if self.valid_extractors.include?(value)
      @@preferred_extractor = value
    else
      raise NotSupportedExtractor
    end
  end
  
  self.preferred_extractor = "alchemy" if self.preferred_extractor.blank?
  
  
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
    @@klass = SemanticExtraction.const_get(self.preferred_extractor.capitalize)
    (@@klass.respond_to?(method) && defined?(self.send((preferred_extractor + "_api_key").to_sym))) ? true : false
  end
  
end