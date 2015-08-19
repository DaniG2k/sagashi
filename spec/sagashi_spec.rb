require 'rails_helper'

describe Sagashi do
  it 'has a version number' do
    expect(Sagashi::VERSION).not_to be nil
  end

  it '❨╯°□°❩╯︵┻━┻ tells angry developers to calm down' do
  	expect(Sagashi.❨╯°□°❩╯︵┻━┻).to eq('Calm down yo!')
  end

  it 'allows configuration via a block' do
  	Sagashi.configure do |conf|
  		conf.index_file = 'indexfile.idx'
  	end
  	expect(Sagashi.configuration.index_file).to eq('indexfile.idx')
  end
end
