module Sagashi
  class Token < ActiveRecord::Base
    serialize :doc_info
  end
end
