# frozen_string_literal: true

require 'json'
require 'mitake/api'

module Mitake
  # The API response
  #
  # @since 0.1.0
  class Response
    include Model

    # @!attribute [r] response
    # @return [Hash] the response
    attribute :response, Hash, readonly: true

    # @since 0.2.0
    # @api private
    def initialize(response)
      @response = response
      @response.each do |key, value|
        instance_variable_set("@#{key}", value)
        self.class.send(:attr_reader, key)
      end
    end

    # @since 0.2.0
    # @api private
    def to_json(options = nil)
      @response.to_json
    end

    # @since 0.2.0
    # @api private
    def status
      Status::CODES[@status_code]
    end

    # Does message is duplicate
    #
    # @return [TrueClass|FalseClass] is the message duplicate
    #
    # @since 0.2.0
    def duplicate?
      @duplicate == true
    end
  end
end
