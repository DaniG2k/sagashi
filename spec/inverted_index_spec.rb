require 'rails_helper'

describe Sagashi::InvertedIndex do
  before :each do
    @index = Sagashi::InvertedIndex.new
    @d1 = Sagashi::Document.new :id => 1, :body => "breakthrough drug for schizophrenia"
    @d2 = Sagashi::Document.new :id => 2, :body => "new schizophrenia drug"
    @d3 = Sagashi::Document.new :id => 3, :body => "new approach for treatment of schizophrenia"
    @d4 = Sagashi::Document.new :id => 4, :body => "new hopes for schizophrenia patients"
    
    @coll = Sagashi::Collection.new
    [@d1,@d2,@d3,@d4].each do |doc|
      @coll.docs << doc
    end
  end

  it "a new InvertedIndex object defaults to having an empty collection" do
    index = Sagashi::InvertedIndex.new
    expect(index.collection).to be_a_kind_of(Sagashi::Collection)
  end

  it '#build makes the inverted index' do
    d1 = Sagashi::Document.new :body => "new home sales top forecasts", :id => 1
    d2 = Sagashi::Document.new :body => "home sales rise in july", :id => 2
    d3 = Sagashi::Document.new :body => "increase in home sales in july", :id => 3
    d4 = Sagashi::Document.new :body => "july new home sales rise", :id => 4
    
    coll = Sagashi::Collection.new
    [d1, d2, d3, d4].each {|d| coll.docs << d}
    @index.collection = coll
    
    result = {
      "new" => {:doc_freq => 2, :ids => {1=>1, 4=>1}},
      "home"=> {:doc_freq => 4, :ids => {1=>1, 2=>1, 3=>1, 4=>1}},
      "sale"=> {:doc_freq => 4, :ids =>{1=>1, 2=>1, 3=>1, 4=>1}},
      "top" => {:doc_freq =>1, :ids => {1=>1}},
      "forecast"=> {:doc_freq => 1, :ids => {1=>1}},
      "rise" => {:doc_freq => 2, :ids => {2=>1, 4=>1}},
      "juli" => {:doc_freq => 3, :ids => {2=>1, 3=>1, 4=>1}},
      "increas" => {:doc_freq => 1, :ids => {3=>1}}
    }
    @index.build
    expect(@index.iidx).to eq(result)
  end

  it '#find returns the document ids for a string' do
    d1 = Sagashi::Document.new :id => 1, :body => "breakthrough drug for schizophrenia"
    d2 = Sagashi::Document.new :id => 2, :body => "new schizophrenia drug"
    coll = Sagashi::Collection.new

    [d1,d2].each {|d| coll.docs << d}
    @index.collection = coll
    @index.build
    expect(@index.find('breakthrough drug')).to eq({:doc_freq=>1, :ids => {1 => 1}})
  end

  it "#find returns an array of document ids for a series of words" do
    d1 = Sagashi::Document.new :body => "As I remember, Adam, it was upon this fashion bequeathed me by will but poor a thousand crowns, and, as thou sayest, charged my brother, on his blessing, to breed me well: and there begins my sadness. My brother Jaques he keeps at school, and report speaks goldenly of his profit: for my part, he keeps me rustically at home, or, to speak more properly, stays me here at home unkept; for call you that keeping for a gentleman of my birth, that differs not from the stalling of an ox? His horses are bred better; for, besides that they are fair with their feeding, they are taught their manage, and to that end riders dearly hired: but I, his brother, gain nothing under him but growth; for the which his animals on his dunghills are as much bound to him as I. Besides this nothing that he so plentifully gives me, the something that nature gave me his countenance seems to take from me: he lets me feed with his hinds, bars me the place of a brother, and, as much as in him lies, mines my gentility with my education. This is it, Adam, that grieves me; and the spirit of my father, which I think is within me, begins to mutiny against this servitude: I will no longer endure it, though yet I know no wise remedy how to avoid it.", :id => 1
    d2 = Sagashi::Document.new id: 2, body: "Shall I compare thee to a summer's day? Thou art more lovely and more temperate: Rough winds do shake the darling buds of May, And summer's lease hath all too short a date: Sometime too hot the eye of heaven shines, And often is his gold complexion dimm'd; And every fair from fair sometime declines, By chance or nature's changing course untrimm'd; But thy eternal summer shall not fade Nor lose possession of that fair thou owest; Nor shall Death brag thou wander'st in his shade, When in eternal lines to time thou growest: So long as men can breathe or eyes can see, So long lives this and this gives life to thee."
    d3 = Sagashi::Document.new id: 3, body: "For shame! deny that thou bear'st love to any, Who for thyself art so unprovident. Grant, if thou wilt, thou art beloved of many, But that thou none lovest is most evident; For thou art so possess'd with murderous hate That 'gainst thyself thou stick'st not to conspire. Seeking that beauteous roof to ruinate Which to repair should be thy chief desire. O, change thy thought, that I may change my mind! Shall hate be fairer lodged than gentle love? Be, as thy presence is, gracious and kind, Or to thyself at least kind-hearted prove: Make thee another self, for love of me, That beauty still may live in thine or thee."
    d4 = Sagashi::Document.new id: 4, body: "Mine eye and heart are at a mortal war How to divide the conquest of thy sight; Mine eye my heart thy picture's sight would bar, My heart mine eye the freedom of that right. My heart doth plead that thou in him dost lie -- A closet never pierced with crystal eyes -- But the defendant doth that plea deny And says in him thy fair appearance lies. To 'cide this title is impanneled A quest of thoughts, all tenants to the heart, And by their verdict is determined The clear eye's moiety and the dear heart's part: As thus; mine eye's due is thy outward part, And my heart's right thy inward love of heart."
    coll = Sagashi::Collection.new docs: [d1,d2,d3,d4]
    index = Sagashi::InvertedIndex.new collection: coll
    index.build
    expect(index.find('my complex string that i shall love forever')).to eq([*1..4])
  end

  it '#query_and performs a conjunctive query' do
    @index.collection = @coll
    @index.build
    expect(@index.query_and(['schizophrenia', 'drug'])).to eq([1, 2])
  end

  it '#query_or performs a disjunctive query' do
    @index.collection = @coll
    @index.build
    expect(@index.query_or(['schizophrenia', 'drug'])).to eq([*1..4])
  end

  it '#remove_doc removes a given document from the inverted index' do
    @index.collection = @coll
    @index.build
    @index.remove_doc(@d1)
    expect(@index.iidx).not_to have_key('breakthrough')
    @index.iidx.each {|k, v| expect(v).not_to include(1)}
  end
end
