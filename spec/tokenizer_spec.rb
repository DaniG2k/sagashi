require 'rails_helper'

describe Sagashi::Tokenizer do
  before :each do
    @tokenizer = Sagashi::Tokenizer.new 
  end

  it 'tokenizes a string' do
    @tokenizer.str = "This is a body."
    expect(@tokenizer.tokenize).to eq(%w(this bodi))
  end

  it 'tokenizes known words properly' do
    @tokenizer.str = 'U.S.A.'
    expect(@tokenizer.tokenize).to eq(['usa'])
    @tokenizer.str = 'anti-discriminatory'
    expect(@tokenizer.tokenize).to eq(['antidiscriminatori'])
  end

  it 'tokenizes a Japanese string' do
    @tokenizer.str = "これは、文書体です。"
    expect(@tokenizer.tokenize).to eq(["これは","文書体です"])
  end

  it 'tokenizes a Korean string' do
    @tokenizer.str = "이것은 문서 체입니다."
    expect(@tokenizer.tokenize).to eq(['이것은', '문서', '체입니다'])
  end

  it 'tokenizes words with apostophes properly' do
    @tokenizer.str = "O'Neill aren't"
    expect(@tokenizer.tokenize).to eq(%w(oneil arent))
  end
end
