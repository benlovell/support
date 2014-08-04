require 'uri'
require 'active_model/tableless_model'

module Support
  module Requests
    module Anonymous
      class Explore < ActiveModel::TablelessModel; end

      class ExploreByUrl < Explore
        attr_accessor :by_url, :by_slug, :day_option, :day
        validates_presence_of :by_url
        validate :well_formed_url

        def path
          URI(by_url).path
        end

        def day_option
          @day_option ||= "today"
        end

        def redirect_path
          Rails.application.routes.url_helpers.anonymous_feedback_index_path(path: path)
        end

        private
        def well_formed_url
          uri = URI.parse(by_url)
          valid = (uri.kind_of?(URI::HTTP) or uri.kind_of?(URI::HTTPS)) && !uri.path.nil? && !uri.host.nil?
          errors.add(:by_url, "must be a valid URL") unless valid
        rescue URI::InvalidURIError
          errors.add(:by_url, "must be a valid URL")
        end
      end

      class ExploreServiceFeedback < Explore
        attr_accessor :slug, :day_option, :specific_day
        validates_presence_of :slug

        def day_option
          @day_option ||= "today"
        end

        def all_slugs
          Support::Requests::Anonymous::ServiceFeedback.uniq.
            select(:slug).
            order("slug asc").
            map(&:slug)
        end

        def redirect_path
          Rails.application.routes.url_helpers.anonymous_feedback_service_feedback_path(
            slug: slug,
            date: 'today'
          )
        end
      end
    end
  end
end
