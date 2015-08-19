require 'rails_helper'

describe Sagashi::Collection do
  it '#containing_term returns the number of documents containing a given term' do
    str = 'Experts worldwide are gathering in the East Asian peninsula to architect the cities of the future'
    doc1 = Sagashi::Document.new :body => str
    doc2 = Sagashi::Document.new :body => 'Eastern Europe'
    coll = Sagashi::Collection.new(:docs => [doc1, doc2])
    
    t = Sagashi::Tokenizer.new('Asian').tokenize.shift
    # Note: containing_term requires a tokenized term
    expect(coll.containing_term(t)).to eq(1)
  end

  it '#<< adds a given document to a collection' do
    doc1 = Sagashi::Document.new(:body => "This is a body.", :id => 1)
    coll = Sagashi::Collection.new
    coll.docs << doc1
    expect(coll.docs[0]).to eq(doc1)
  end

  it '#avg_dl returns the average document length' do
    doc1 = Sagashi::Document.new(:body => "This is a body.", id: 1)
    doc2 = Sagashi::Document.new(:body => "This is another body.", id: 2)
    doc3 = Sagashi::Document.new(:body => "This is a really really long body.", id: 3)
    coll = Sagashi::Collection.new

    [doc1, doc2, doc3].each do |doc|
      coll.docs << doc
    end

    test_avg_dl = (doc1.length + doc2.length + doc3.length) / 3
    expect(coll.avg_dl).to eq(test_avg_dl)
  end

  it '#total_docs returns the total number of documents' do
    doc1 = Sagashi::Document.new(:body => "This is a body.")
    doc2 = Sagashi::Document.new(:body => "This is another body.")
    coll = Sagashi::Collection.new(:docs => [doc1, doc2])

    expect(coll.total_docs).to eq(2)
  end
end
