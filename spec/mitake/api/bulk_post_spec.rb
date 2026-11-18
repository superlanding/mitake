# frozen_string_literal: true

RSpec.describe Mitake::API::BulkPost do
  let(:credential) { Mitake::Credential.new('user', 'pass', 'https://example.com') }
  let(:body) { "1$$0912345678$$$$$$Hello\n2$$0987654321$$$$$$World" }
  let(:api) { described_class.new('/send', body) }

  before { allow(Mitake).to receive(:credential).and_return(credential) }

  describe '#request' do
    subject(:request) { api.request }

    it 'sets the form content type' do
      expect(request['Content-Type']).to eq 'application/x-www-form-urlencoded'
    end

    it 'uses the params as the body' do
      expect(request.body).to eq body
    end
  end
end
