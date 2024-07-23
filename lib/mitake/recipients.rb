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

    def initialize(attributes = {})
      @recipients = []
      super(attributes)
    end

    # @since 0.2.0
    def add(attributes)
      @recipients << Recipient.new(attributes)
    end

    # @since 0.2.0
    def map(&block)
      @recipients.map(&block)
    end
  end
end
