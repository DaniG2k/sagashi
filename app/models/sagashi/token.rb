module Sagashi
  class Token < ActiveRecord::Base
    validates_presence_of :term
    serialize :doc_info
  end
end