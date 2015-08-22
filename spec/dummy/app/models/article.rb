class Article < ActiveRecord::Base
  include Sagashi
  
  validates_presence_of :title, :body
end
