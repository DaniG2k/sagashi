module Sagashi
  class InvertedIndex < ActiveRecord::Base
    has_many :tokens, dependent: :destroy
  end
end
