require 'spec_helper'

RSpec.describe Article do
  it "has a constructor" do
    a = Article.new
    expect(a).to_not be_nil
  end
end
