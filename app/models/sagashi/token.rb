module Sagashi
  class Token < ActiveRecord::Base
    validates_presence_of :term
    # A hash of :field => [docId,docId]
    serialize :doc_info
    # An array of spelling suggestions
    serialize :spelling_suggestions
  end
end