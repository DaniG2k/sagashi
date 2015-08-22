require 'sagashi/engine'
require 'sagashi/query_parser'
require 'sagashi/document'
require 'sagashi/collection'
require 'sagashi/tokenizer'
require 'sagashi/ranker'
require 'sagashi/inverted_index'
require 'sagashi/spelling_suggester'
require 'sagashi/models/active_record_extension'

require 'pry'
require 'lingua/stemmer'

module Sagashi
  def self.❨╯°□°❩╯︵┻━┻
    'Calm down yo!'
  end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @config ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  class Configuration
    attr_accessor :language,
                  :stopwords,
                  :index_text_fields

    def initialize
      #@app_id = 'default'
      # Should be more like Rails.root.join('db', 'index.json')
      # for integration with a Rails app:
      @language = 'en'
      @stopwords = %w(a an and are as at be by for from has he in is it its of on she that the to was were will with)
      @index_text_fields = Array.new
    end
  end
end