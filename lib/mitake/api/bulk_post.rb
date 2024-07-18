# frozen_string_literal: true

require 'mitake/api/base'

module Mitake
  module API
    # Create Special HTTP Post Request for bulk sending
    #
    # @since 0.2.0
    # @api private
    class BulkPost < Base
      # Create HTTP Post Request
      #
      # @since 0.2.0
      # @api private
      def request
        return @request unless @request.nil?

        @request ||= Net::HTTP::Post.new(uri)
        @request.body = params
        @request
      end

      # @see Mitake::API::Base#uri
      #
      # @since 0.2.0
      # @api private
      def uri
        @uri ||= URI("#{Mitake.credential.server}#{@path}?username=#{Mitake.credential.username}&password=#{Mitake.credential.password}")
      end

      # Return the request params
      #
      # @return [Hash] the query params
      #
      # @since 0.1.0
      # @api private
      def params
        @params
      end
    end
  end
end
