# frozen_string_literal: true

require 'mitake/model/attributes'
require 'mitake/model/accessor'

module Mitake
  # Provide attributes accessor
  #
  # @since 0.1.0
  # @api private
  module Model
    # @since 0.1.0
    # @api private
    def self.included(base)
      base.class_eval do
        include Attributes
        extend Accessor
      end
    end

    # Get attributes as hash
    #
    # @return [Hash] the object attributes
    #
    # @since 0.1.0
    def attributes
      self
        .class
        .attribute_names
        .map { |attr| [attr, send(attr)] }
        .compact
        .transform_values do |value|
        value.respond_to?(:attributes) ? value.attributes : value
      end
    end
  end
end
