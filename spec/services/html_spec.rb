require 'spec_helper'

describe Html do
  let(:simple_content) { fixture_file_content('simple01.html') }
  let(:simple) { Html.new(content: simple_content) }
  let(:bemused) { Html.new(content: fixture_file_content('bemused01.html')) }

  it "is instantiated with content" do
    expect(simple.title).to eq("pfarrell")
    expect(simple.content).to_not be_nil
  end

  it "parses a source address" do
    h=Html.new(url: "http://example.com")
    expect(h.host).to eq ("example.com")
    expect(h.scheme).to eq("http")
  end

  it "can normalize protocol neutral urls" do
    h=Html.new(url: "http://example.com")
    expect(h.normalize("//example.com/images/test.jpg")).to eq("http://example.com/images/test.jpg")
  end

  it "can get favicons defined in html" do
    bemused.uri = Scraper.new.uri("https://patf.net")
    expect(bemused.favicon).to eq("https://patf.net/images/bemused.ico")
  end

  it "can get favicons not defined in html" do
    h=Html.new(content: simple_content)
    h.uri = Scraper.new.uri("http://example.com")
    expect(h.favicon).to eq("http://example.com/favicon.ico")
  end

  it "can get meta tags" do
    expect(bemused.meta).to be_a Hash
  end

  it "can find canonical links" do
    expect(bemused.canonical).to eq([])
  end

  it "ignores multiple canonical links and returns first one" do
    expect(Html.new(content:simple_content).canonical).to eq("https://example.com/simple01.html")
  end

  it "detects h1 tags" do
    expect(simple.headings).to eq([])
  end

  it "detects h1 tags" do
    expect(simple.headings("1")).to eq([])
  end

  it "detects h2 tags" do
    expect(simple.headings("2")).to eq([])
  end

  it "detects h3 tags" do
    expect(simple.headings("3")).to eq(["Bits"])
  end

  it "detects h4 tags" do
    expect(simple.headings("4")).to eq([])
  end

  it "detects h5 tags" do
    expect(simple.headings("5")).to eq([])
  end

  it "detects img tags" do
    expect(bemused.images).to be_a Array
    expect(bemused.images.size).to eq(25)
  end

  it "sorts images by file size using head... don't laugh" do
    s=Scraper.new
    sorted=s.sort_file_sizes("https://patf.net", bemused.images)
    expect(sorted.first).to eq("/bemused/images/artists/sm/wu_tang_clan.jpg")
    expect(sorted.last).to eq("/bemused/images/artists/sm/jimi_hendrix.gif")
  end

  it "detects link tags" do
    expect(bemused.links).to be_a Array
    expect(bemused.links.size).to eq(27)
  end
    
  it "detects external link tags" do
    bemused.uri=Scraper.new.uri("http://example.com/bemused")
    expect(bemused.external_links).to be_a Array
    expect(bemused.external_links.size).to eq(1)
  end
    
  it "detects internal link tags" do
    bemused.uri=Scraper.new.uri("http://example.com/bemused")
    expect(bemused.internal_links).to be_a Array
    expect(bemused.internal_links.size).to eq(27)
  end

  it "strips html" do
    expect(simple.content).to eq("")
  end
    
end
