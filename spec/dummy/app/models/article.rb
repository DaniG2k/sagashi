class Article < ActiveRecord::Base
  include Sagashi
  Sagashi.configure do |c|
    c.language = 'en'
    c.index_text_fields = [:title, :body]
  end

  validates_presence_of :title, :body
end
