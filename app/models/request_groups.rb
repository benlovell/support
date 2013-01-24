class RequestGroups
  include Enumerable

  def initialize
    @groups = [
      RequestGroup.new("Content request", [ContentChangeRequest, NewFeatureRequest]),
      RequestGroup.new("User Access", [CreateNewUserRequest, RemoveUserRequest]),
      RequestGroup.new("Campaigns", [CampaignRequest]),
      RequestGroup.new("Other Issues", [GeneralRequest]),
    ]
  end

  def each(&block)
    @groups.each(&block)
  end
end