require 'rails_helper'

describe FeedexHelper, type: :helper do
  include FeedexHelper

  context "#total_responses_header" do
    let(:header) {
      total_responses_header(
        total_count: total_count,
        from: from,
        to: to,
      )
    }

    context "with no dates and a total_count of 1" do
      let(:total_count) { 1 }
      let(:from) { nil }
      let(:to) { nil }

      it "outputs total_count" do
        expect(header).to eq("1 response")
      end
    end

    context "with no dates and a total_count more than 1" do
      let(:total_count) { 1000 }
      let(:from) { nil }
      let(:to) { nil }

      it "outputs total_count" do
        expect(header).to eq("All 1,000 responses")
      end
    end

    context "with only a from date" do
      let(:total_count) { 1000 }
      let(:from) { "10 May 2015" }
      let(:to) { nil }

      it "outputs total_count and from date" do
        expect(header).to eq("1,000 responses since 10 May 2015")
      end
    end

    context "with only a to date" do
      let(:total_count) { 1000 }
      let(:from) { nil }
      let(:to) { "11 May 2015" }

      it "outputs total_count and to date" do
        expect(header).to eq("1,000 responses before 11 May 2015")
      end
    end

    context "with both a from and to date" do
      let(:total_count) { 1000 }
      let(:from) { "10 May 2015" }
      let(:to) { "11 May 2015" }

      it "outputs total_count and both dates" do
        expect(header).to eq("1,000 responses between 10 May 2015 and 11 May 2015")
      end
    end
  end
end
