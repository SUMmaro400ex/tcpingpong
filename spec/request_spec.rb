require './lib/request.rb'
describe Request do

  subject do
    described_class.new do |r|
      r.http_method = "GET"
      r.path = "/index.html"
    end
  end

  context "#initialize" do
    it "accepts a block yielding itself" do
      described_class.new do |request|
        expect(request).to be_a(described_class)
      end
    end
    it "defaults post_data to an empty hash" do
      expect(subject.post_data).to eq({})
    end
  end
  context "#headers" do
    it "is a Hash" do
      expect(subject.headers).to be_a Hash
    end
  end
  context "#info" do
    it "returns a string of the HTTP method and path" do
      expect(subject.info).to eq "GET /index.html"
    end
  end
  context "#params" do
    it "merges the query hash and post_data hash and memoizes it" do
      subject.query = { r: :red }
      subject.post_data = { b: :blue }
      expect(subject.params).to eq r: :red, b: :blue
    end
  end
  context "#cookies" do
    it "returns a hash" do
      expect(subject.cookies).to eq({})
    end

  end
  context "#content_length" do
    it "returns an integer" do
      expect(subject.content_length).to be 0
    end
  end
end