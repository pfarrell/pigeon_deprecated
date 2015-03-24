require 'spec_helper'

describe Scraper do

  it 'has a doc and uri property' do
    c=fixture_file_content('simple01.html')
    s = Scraper.new
    s.doc
    expect(s.url).to be_nil
    expect(s.doc).to be_nil
  end
end
