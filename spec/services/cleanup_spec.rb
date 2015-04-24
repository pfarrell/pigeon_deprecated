require 'spec_helper'

describe Cleanup do
  let(:cp) {Cleanup.new}

  it "formats urls" do
    expect(cp.url("test")).to eq("http://localhost:8080/content?url=test")
  end

  it "sets hosts" do
    cp=Cleanup.new("http://example.com")
    expect(cp.url("test")).to eq("http://example.com/content?url=test")
  end
end
