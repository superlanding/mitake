# frozen_string_literal: true

RSpec.describe Mitake do
  it 'has a version number' do
    expect(Mitake::VERSION).not_to be nil
  end

  describe 'sending SMS' do
    let(:recipient) { Mitake::Recipient.new(phone_number: '09xxxxxxxx', name: 'John') }
    let(:message) { Mitake::Message.new(recipient: recipient, body: 'Hello World!') }
    let(:response_data) do
      [{ 'source_id' => 1, 'id' => '#000000333', 'status_code' => '0', 'account_point' => '92', 'sms_point' => '1.2' }]
    end
    let(:expected_response) { Mitake::Response.new(response_data.first) }

    before do
      allow(Mitake::Message).to receive(:execute).and_yield(response_data)
    end

    it 'is not send initially' do
      expect(message.sent?).to be false
    end

    describe 'when delivering the message' do
      before do
        message.delivery
      end

      it 'marks the message as sent' do
        message.delivery
        expect(message.sent?).to be true
      end

      it 'sets the response correctly' do
        expect(message.response).to be_instance_of(Mitake::Response)
        expect(message.response.status_code).to eq(expected_response.status_code)
        expect(message.response.account_point).to eq(expected_response.account_point)
      end
    end
  end

  describe 'sending bulk SMS' do
    let(:recipients) do
      [
        Mitake::Recipient.new(phone_number: '09xxxxxxxx', name: 'John', body: 'Hello John'),
        Mitake::Recipient.new(phone_number: '09xxxxxxxx', name: 'Mary', body: 'Hello Mary'),
        Mitake::Recipient.new(phone_number: '09xxxxxxxx', name: 'Tom')
      ]
    end
    let(:message) { Mitake::BulkMessage.new(recipients: recipients, body: 'Hello World!') }
    let(:response_data) do
      [
        { 'source_id' => 1, 'id' => '#000000111', 'status_code' => '0', 'account_point' => '92', 'sms_point' => '1.2' },
        { 'source_id' => 2, 'id' => '#000000222', 'status_code' => '0', 'account_point' => '88', 'sms_point' => '1.2' }
      ]
    end
    let(:expected_responses) do
      response_data.map do |data|
        Mitake::Response.new(data)
      end
    end

    before do
      allow(Mitake::BulkMessage).to receive(:execute).and_yield(response_data)
    end

    it 'is not send initially' do
      expect(message.sent?).to be false
    end

    describe 'when delivering the message' do
      before do
        message.delivery
      end

      it 'marks the message as sent' do
        message.delivery
        expect(message.sent?).to be true
      end

      it 'sets the response correctly' do
        expect(message.responses).to all(be_instance_of(Mitake::Response))
        expect(message.responses.first.status_code).to eq(expected_responses.first.status_code)
        expect(message.response.first.account_point).to eq(expected_responses.first.account_point)
      end
    end
  end
end
