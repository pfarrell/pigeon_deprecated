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

  it "saves documents to elasticsearch" do
    e=ElasticSearch.new("pigeon_test", "test")
    e.hostname="Test Source"
    e.canonical="http://example.com/test"
    e.date=Time.now
    e.image="test_image.jpg"
    e.content="test content"
    e.id=1
    setup_method!(:put, "http://localhost:9200/#{e.index}/#{e.type}/#{e.id}", e.to_json)


    e.save
    expect(e.id).to eq(1)
  end
end
