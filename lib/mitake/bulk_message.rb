# frozen_string_literal: true

require 'mitake/model'
require 'mitake/recipients'
require 'mitake/response'
require 'mitake/boolean'
require 'mitake/status'

module Mitake
  # Create Sort Message
  #
  # @since 0.2.0
  class BulkMessage
    include API
    include Model

    method 'BulkPost'
    path "/b2c/mtk/SmBulkSend?Encoding_PostIn=UTF8"
    map 'msgid', 'id'
    map 'Duplicate', 'duplicate'
    map 'statuscode', 'status_code'

    # @!attribute [r] id
    # @return [String] the message id
    attribute :id, String, readonly: true

    # @!attribute source_id
    # @return [String] the customize identity
    attribute :source_id, String

    # @!attribute receipient
    # @return [Mitake::Recipients] the message recipient
    attribute :recipients, Recipients

    # @!attribute body
    # @return [String] the message body
    attribute :body, String

    # @!attribute schedule_at
    # @return [Time|NilClass] the schedule time to send message
    attribute :schedule_at, Time

    # @!attribute expired_at
    # @return [Time|NilClass] the valid time for this message
    attribute :expired_at, Time

    # @!attribute webhook_url
    # @return [String|NilClass] the response callback url
    attribute :webhook_url, String

    # @!attribute [r] duplicate
    # @return [TrueClass|FalseClass] is the message duplicate
    attribute :duplicate, Boolean, readonly: true

    # @!attribute [r] status_code
    # @return [Integer] the status code
    attribute :status_code, Integer, readonly: true

    # Send message
    #
    # @since 0.2.0
    # @api private
    def delivery
      return self if sent?

      self.class.execute(params) do |items|
        attrs = items&.first&.slice(*self.class.attribute_names)
        assign_attributes(attrs)
      end

      self
    end

    # Does message is sent
    #
    # @return [TrueClass|FalseClass] is the message sent
    #
    # @since 0.2.0
    def sent?
      !@id.nil?
    end

    # Does message is duplicate
    #
    # @return [TrueClass|FalseClass] is the message duplicate
    #
    # @since 0.2.0
    def duplicate?
      @duplicate == true
    end

    # Readable status code
    #
    # @return [String] the status code description
    #
    # @since 0.2.0
    def status
      Status::CODES[@status_code]
    end

    private

    # The request params
    #
    # @since 0.2.0
    # @api private
    def params
      @recipients.map.with_index do |recipient, index|
        [
          index + 1,
          recipient.phone_number,
          @schedule_at&.strftime('%Y%m%d%H%M%S'),
          @expired_at&.strftime('%Y%m%d%H%M%S'),
          recipient.name,
          @webhook_url,
          recipient.message? ? recipient.message : @body,
        ].join('$$')
      end.join("\r\n")
    end
  end
end
