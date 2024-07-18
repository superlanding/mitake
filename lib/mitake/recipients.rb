# frozen_string_literal: true

require 'mitake/model'

module Mitake
  # The recipients
  #
  # @since 0.2.0
  class Recipients
    include Model

    # @since 0.2.0
    attribute :recipients, [Recipient]

    def initialize
      @recipients = []
      super
    end

    # @since 0.2.0
    def add(name, phone_number, message = nil)
      @recipients << Recipient.new(name: name, phone_number: phone_number, message: message)
    end

    # @since 0.2.0
    def map(&block)
      @recipients.map(&block)
    end
  end
end
