require 'spec_helper'

describe ElasticSearch do
  it "can be instantiated with index and a type" do
    e=ElasticSearch.new("index", "type")
    expect(e.type).to eq("type")
    expect(e.index).to eq("index")
    expect(e.host).to eq("http://localhost:9200")
  end

  it "can be instantiated with index, type, and host" do
    e=ElasticSearch.new("index", "type", "http://example.com")
    expect(e.type).to eq("type")
    expect(e.index).to eq("index")
    expect(e.host).to eq("http://example.com")
  end

  it "constructs elastic search endpoint urls for documents" do
    e=ElasticSearch.new("index", "type", "http://example.com")
    e.id = 1
    expect(e.es_url).to eq("http://example.com/index/type/1")
  end
end
