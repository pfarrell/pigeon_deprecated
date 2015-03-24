require 'spec_helper'

describe Scraper do

  it 'has a doc and uri property' do
    c=fixture_file_content('simple01.html')
    s = Scraper.new
    s.doc
    expect(s.url).to be_nil
    expect(s.doc).to be_nil
  end

  it "scrapes" do
    s="http://patf.net"
    expect(Scraper.newlfinal_url(s)).to eq ("http://pfarrell.github.io")
  end
  
  it "detects when 200's are returned" do
    s = Scraper.new
    expect(s.final_url("https://pfarrell.github.io/")).to eq ("https://pfarrell.github.io/")
  end

  it "normalizes urls" do
    s = Scraper.new
    expect(s.normalize("http://patf.net", "http://patf.net/test.jpg")).to eq ("http://patf.net/test.jpg")
  end

  it "normalizes urls" do
    s = Scraper.new
    expect(s.normalize("http://patf.net", "/test.jpg")).to eq ("http://patf.net/test.jpg")
  end
end
