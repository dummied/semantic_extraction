module SemanticExtraction
  module UtilityMethods
    
    def self.included(includer)
      includer.module_eval do

        # Posts the url to the API.
        def self.post(url, target, calling_param, api_param="apikey".to_sym)
          RubyTubesday.new.post(url, :params => {calling_param => target, api_param => (SemanticExtraction.send((SemanticExtraction.preferred_extractor + "_api_key").to_sym))} )
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
    end
    
    
  end
end