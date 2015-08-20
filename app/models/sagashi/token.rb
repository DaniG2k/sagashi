module Sagashi
  class Token < ActiveRecord::Base
    belongs_to :inverted_index
    serialize :doc_info
  end
end
