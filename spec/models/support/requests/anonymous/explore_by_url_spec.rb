require 'rails_helper'
require 'support/requests/anonymous/explore'

module Support
  module Requests
    module Anonymous
      describe ExploreByUrl do
        it { should validate_presence_of(:url) }

        it { should allow_value("https://www.gov.uk/test").for(:url) }
        it { should_not allow_value("https:aaaa").for(:url).with_message(/must be a valid URL/) }

        it "works out the path to redirect to from the URL" do
          expect(ExploreByUrl.new(url: "https://www.gov.uk/some-path").redirect_path).
            to eq("/anonymous_feedback?path=%2Fsome-path")
        end
      end
    end
  end
end