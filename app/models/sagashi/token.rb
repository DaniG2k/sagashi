module Sagashi
  class Token < ActiveRecord::Base
    serialize :doc_info
    validates :term, presence: true
  end
end
