require 'uri'
require 'support/requests/anonymous/anonymous_contact'

module Support
  module Requests
    module Anonymous
      class ProblemReport < AnonymousContact
        attr_accessible :what_doing, :what_wrong, :source, :page_owner

        validates :referrer, url: true, allow_nil: true

        validates :what_doing, length: { maximum: 2 ** 16 }
        validates :what_wrong, length: { maximum: 2 ** 16 }

        def referrer_url_on_gov_uk?
          referrer and URI.parse(referrer).host == "www.gov.uk"
        end
      end
    end
  end
end
