class Article < ActiveRecord::Base
  include Sagashi
  Sagashi.configure do |c|
    c.language = 'en'
  end

  validates_presence_of :title, :body

end
