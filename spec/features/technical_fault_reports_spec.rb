require 'rails_helper'

feature "Technical fault reports" do
  # In order to minimise user inconvenience and damage to government reputation
  # As a government employee
  # I want to report technical faults in GDS-managed tools to the appropriate teams

  let(:user) { create(:user, name: "John Smith", email: "john.smith@agency.gov.uk") }

  background do
    login_as user
    zendesk_has_no_user_with_email(user.email)
  end

  scenario "successful report" do
    request = expect_zendesk_to_receive_ticket(
      "subject" => "Technical fault report",
      "requester" => hash_including("name" => "John Smith", "email" => "john.smith@agency.gov.uk"),
      "tags" => [ "govt_form", "technical_fault", "fault_with_gov_uk_mainstream" ],
      "comment" => { "body" =>
"[Location of fault]
GOV.UK: Services and information content

[What is broken]
Smart answer

[Actions leading to problem]
Clicked on x

[What happened]
Broken link

[What should have happened]
Should have linked through"})

    user_makes_a_technical_fault_report(
      location_of_fault: "GOV.UK: Services and information content",
      what_is_broken: "Smart answer",
      user_action: "Clicked on x",
      what_happened: "Broken link",
      what_should_have_happened: "Should have linked through",
    )

    expect(request).to have_been_made
  end

  private
  def user_makes_a_technical_fault_report(details)
    visit '/'

    click_on "Report a technical fault"

    expect(page).to have_content("Report a technical fault to GDS")

    within "#technical-fault-context" do
      choose details[:location_of_fault]
    end

    fill_in "How much is it affecting? (the whole thing, a specific feature or specific URLs)",
      with: details[:what_is_broken]

    fill_in "What were you trying to do?",
      with: details[:user_action]

    fill_in "What happened?",
      with: details[:what_happened]

    fill_in "What should have happened?",
      with: details[:what_should_have_happened]

    user_submits_the_request_successfully
  end
end
