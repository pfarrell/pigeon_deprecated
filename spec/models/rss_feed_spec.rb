require 'spec_helper'

RSpec.describe RssFeed do
  it "has a constructor" do
    expect(RssFeed.new).to_not be_nil
  end
end
