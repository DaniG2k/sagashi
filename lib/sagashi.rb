require "sagashi/engine"
require 'sagashi/query_parser'
require 'sagashi/document'
require 'sagashi/collection'
require 'sagashi/tokenizer'
require 'sagashi/ranker'
require 'sagashi/inverted_index'
require 'sagashi/spelling_suggester'
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
    attr_accessor :app_id,
                  :index_file,
                  :language, 
                  :stopwords

    def initialize
      @app_id = 'default'
      # Should be more like Rails.root.join('db', 'index.json')
      # for integration with a Rails app:
      @index_file = "db/#{@app_id}-index.json"
      @language = 'en'
      @stopwords = %w(a an and are as at be by for from has he in is it its of on she that the to was were will with)
    end
  end
end