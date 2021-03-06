require 'spec_helper'

RSpec.describe 'Upbit integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:eth_krw_pair) { Cryptoexchange::Models::MarketPair.new(base: 'eth', target: 'krw', market: 'upbit') }

  it 'fetch pairs' do
    pairs = client.pairs('upbit')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'upbit'
  end

  it 'does not include non ACTIVE pairs' do
    pairs = client.pairs('upbit')
    expect((pairs.select { |p| p.base == 'TRIG' }).empty?).to be true
  end

  it 'fetch ticker' do
    ticker = client.ticker(eth_krw_pair)

    expect(ticker.base).to eq 'ETH'
    expect(ticker.target).to eq 'KRW'
    expect(ticker.market).to eq 'upbit'
    expect(ticker.last).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be_a Numeric
    expect(2000..Date.today.year).to include(Time.at(ticker.timestamp).year)
    expect(ticker.payload).to_not be nil
  end
end
