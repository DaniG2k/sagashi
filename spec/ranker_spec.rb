require 'rails_helper'

describe Sagashi::Ranker do
  it '#idf returns the inverse document frequency' do
    doc1 = Sagashi::Document.new(:body => "This is a body.")
    doc2 = Sagashi::Document.new(:body => "This is another body.")
    doc3 = Sagashi::Document.new(:body => "This is a really really long body.")
    ranker = Sagashi::Ranker.new

    [doc1, doc2, doc3].each do |doc|
      ranker.docs << doc
    end
    term = Sagashi::Tokenizer.new('another').tokenize.shift

    expect(ranker.idf(term)).to be_within(0.0001).of(0.5108)
  end

  it '#bm25 calculates the score of docs in a collection using the Okapi BM25+ algorithm' do
    doc1 = Sagashi::Document.new(:body => "To reduce the estimated construction cost of ¥252 billion and ease growing criticism, Prime Minister Shinzo Abe said Friday that the new National Stadium to be built for the 2020 Tokyo Olympics will be redesigned from scratch. This means Japan will renege on its promise to use the venue for the 2019 Rugby World Cup because the new stadium won’t be built in time, Abe said.")
    doc2 = Sagashi::Document.new(:body => "It's never too late to learn, at least for this Chinese great grandmother. Zhao Shunjin, from Hangzhou in eastern China, has just been taught how to write her own name at the ripe age of 100. Her son, Luo Rongsheng, 70, told CNN that Zhao announced at a family dinner in June that she would like to learn how to read and write. She has now mastered about 100 Chinese characters after taking an intensive 10-day literacy program held by her neighborhood committee, according to Luo.")
    doc3 = Sagashi::Document.new(:body => "The Japanese government has decided to scrap its controversial plans for the stadium for the 2020 Tokyo Olympics and Paralympics. Prime Minister Shinzo Abe said his government would \"start over from zero\" and find a new design. The original design, by British architect Zaha Hadid, had come under criticism as estimated building costs rose to $2bn (£1.3bn) Mr Abe says the new stadium will still be completed in time for the games. However, the delay means that the stadium will no longer be ready in time for the 2019 Rugby World Cup, which Japan is also hosting. \"I have been listening to the voices of the people and the athletes for about a month now, thinking about the possibility of a review,\" Mr Abe said.")
    ranker = Sagashi::Ranker.new(:docs => [doc1, doc2, doc3], :query => 'Shinzo Abe said')
    
    ranker.bm25
    ranks = ranker.docs.collect {|doc| doc.rank}.sort
    expect(ranks[0]).to be_within(0.001).of(0.181)
    expect(ranks[1]).to be_within(0.001).of(0.984)
    expect(ranks[2]).to be_within(0.001).of(3.00)
  end
end
