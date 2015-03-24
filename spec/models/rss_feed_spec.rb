require 'spec_helper'

RSpec.describe RssFeed do
  it "has a constructor" do
    expect(RssFeed.new).to_not be_nil
    expect(r.type).to eq("rss")
  end

  it "is instantated with a hash" do
    r=RssFeed.new
    r=r.instantiate(title: "test title", url: "http://example.org")
    expect(r.title).to eq("test title")
    expect(r.url).to eq("http://example.org")
    expect(r.type).to eq("rss")
  end
end
