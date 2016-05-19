require './lib/http_parser.rb'

describe HttpParser do
  subject { described_class.new }

  context '#parse' do
    it 'with a nil request raises an empty request error' do
      request = StringIO.new("")
      expect{ subject.parse(request) }.to raise_error EmptyRequestError
    end
    context 'with valid request' do
      before do
        @request = StringIO.new "POST /todos HTTP 1.1\r\nHost: localhost:3000\r\nContent-length: 3\r\nContent-Type: application/x-www-form-urlencoded\r\n\r\nq=1"
      end
      it 'returns a request object' do
        expect(subject.parse(@request) ).to be_a Request
      end
      it 'parses the correct HTTP method' do
        expect(subject.parse(@request).http_method ).to eq 'POST'
      end
      it 'parses the correct path' do
        expect(subject.parse(@request).path).to eq "/todos"
      end
      it 'parses the correct headers' do
        expect(subject.parse(@request).headers).to eq 'Host' => 'localhost:3000', 'Content-length' => '3', 'Content-Type' => 'application/x-www-form-urlencoded'
      end
      it 'reads the request body and parses it into a hash' do
        expect( subject.parse(@request).post_data ).to eq({"q" => "1"})
      end
    end
  end
end