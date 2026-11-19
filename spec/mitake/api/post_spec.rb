# frozen_string_literal: true

RSpec.describe Mitake::API::Post do
  let(:credential) { Mitake::Credential.new('user', 'pass', 'https://example.com') }
  let(:api) { described_class.new('/send', dstaddr: '0912345678', smbody: 'Hello') }

  before { allow(Mitake).to receive(:credential).and_return(credential) }

  describe '#request' do
    subject(:request) { api.request }

    it 'sets the form content type' do
      expect(request['Content-Type']).to eq 'application/x-www-form-urlencoded'
    end

    it 'encodes the params as the body' do
      expect(request.body).to eq 'dstaddr=0912345678&smbody=Hello&username=user&password=pass'
    end
  end
end
