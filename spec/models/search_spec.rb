require 'spec_helper'

describe Search do
  it "ummm... searches" do
    s=Search.new
    results=s.lookup("test").all
    expect(results).to be_a(Array)
  end
end
