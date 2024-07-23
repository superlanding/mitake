# frozen_string_literal: true

require 'mitake/model'

module Mitake
  # The recipient
  #
  # @since 0.1.0
  class Recipient
    include Model

    # @since 0.1.0
    attribute :client_id, String
    attribute :name, String
    attribute :phone_number, String
    attribute :message, String

    # @since 0.2.0
    def message?
      return false if message.nil? || message.empty?

      true
    end

    # @since 0.2.0
    def client_id
      @client_id || @phone_number
    end
  end
end
