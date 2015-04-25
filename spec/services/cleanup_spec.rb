require 'spec_helper'

describe Cleanup do
  let(:cp) {Cleanup.new}
  let(:cleaned) { fixture_file_content('cleaned.json') }

  it "formats urls" do
    expect(cp.url("test")).to eq("http://localhost:8080/content?url=test")
  end

  it "sets hosts" do
    cp=Cleanup.new("http://example.com")
    expect(cp.url("test")).to eq("http://example.com/content?url=test")
  end

  it "removes boilerplate" do
    stub_request(:get, "http://localhost:8080/content?url=http://example.com/index.html").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => cleaned, :headers => {})
    cp=Cleanup.new.clean("http://example.com/index.html")
    expect(cp["content"]).to eq("")
  end
end
