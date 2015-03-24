require 'spec_helper'

RSpec.describe RssFeed do
  it "has a constructor" do
    rss=RssFeed.new
    expect(rss).to_not be_nil
  end

end
