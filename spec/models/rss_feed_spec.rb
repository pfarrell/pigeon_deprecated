require 'spec_helper'

RSpec.describe RssFeed do

  let(:feed) { RssFeed.new(url: "./spec/fixtures/hacker_news.rss") }

  it "has a constructor" do
    rss=RssFeed.new
    expect(rss).to_not be_nil
  end

  it "parses feeds" do
    expect(feed.articles.size).to eq(30)
  end

  it "gets articles from feeds" do
    expect(feed.articles.first.title).to eq("Apple Acquires FoundationDB")
    expect(feed.articles.last.title).to eq("How Secular Stagnation Came to Smurf Village")
  end

  it "yields articles when given a block" do
    ctr=0
    feed.articles{|a| ctr += 1}
    expect(ctr).to eq(30)
  end

end
