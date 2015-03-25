require 'spec_helper'

RSpec.describe Article do
  let(:article) { RssFeed.new(url: "./spec/fixtures/hacker_news.rss").articles.first }

  it "has a constructor" do
    expect(article).to_not be_nil
  end

  it "has source_urls" do
    expect(article.source_urls).to_not be_nil
    expect(article.source_urls['content']).to eq("http://techcrunch.com/2015/03/24/apple-acquires-durable-database-company-foundationdb")
    expect(article.source_urls['comments']).to eq("https://news.ycombinator.com/item?id=9259986")
  end
end
