require 'spec_helper'

describe Scraper do

  it 'has a doc and uri property' do
    c=fixture_file_content('simple01.html')
    s = Scraper.new
    s.doc
    expect(s.url).to be_nil
    expect(s.doc).to be_nil
  end

  it "follows redirects" do
    page="http://patf.net"
    dest="https://patf.net/"
    setup_redirect!(:head, page, dest)
    setup_method!(:head, dest, "./spec/fixtures/simple01.html") 
    expect(Scraper.new.final_url(page)).to eq ("https://patf.net/")
  end

  it "gets favicons" do
    s = Scraper.new
    expect( s.favicon("https://patf.net/bemused")).to eq("https://patf.net/favicon.ico")
  end

  it "scrapes pages" do
    page="http://pfarrell.github.io"
    setup_method!(:get, page, "./spec/fixture/simple01.html")
    setup_method!(:head, page, "./spec/fixture/simple01.html")
    s = Scraper.scrape(page)
    expect(s.url).to eq(page)
    expect(s.final).to eq(page)
    expect(s.doc).to be_a Html
  end
  
  it "detects when 200's are returned" do
    setup_redirect!(:head, "https://pfarrell.github.io/", "https://pfarrell.github.io/")
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
