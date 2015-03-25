require 'spec_helper'

describe Capture do
  
  let(:capture) {Capture.new}

  it 'generates a short directory' do
    expect(capture.short_dir).to_not be_nil
  end

  it 'cleans filenames' do
    expect(capture.clean("test#frag")).to eq("test.html")
  end

  it 'cleans filenames' do
    expect(capture.clean("test.html?")).to eq("test.html")
  end

  it 'cleans filenames' do
    expect(capture.clean("test/")).to eq ("index.html")
  end

  it 'cleans filenames' do
    expect(capture.clean("test/a.pdf")).to eq ("a.pdf")
  end

  it 'cleans filenames' do
    expect(capture.clean("test/a.jpeg")).to eq ("a.jpeg")
  end

  it 'cleans filenames' do
    expect(capture.clean("test/a.jpg")).to eq ("a.jpg")
  end

  it 'cleans filenames' do
    expect(capture.clean("test/a.gif")).to eq ("a.gif")
  end

  it "is downloadable" do
    article=Article.new(url: "http://example.com")
    article.save
    capture = Capture.new(article: article)
    dir=capture.download!
    expect(dir).to_not be_nil
  end
  
end
