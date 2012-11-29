require 'zendesk_ticket'
require 'comment_snippet'

class NewFeatureRequestZendeskTicket < ZendeskTicket
  attr_reader :time_constraint

  def subject
    @request.inside_government_related? ? "New Feature Request" : "New Need Request"
  end

  def tags
    specific_tag = @request.inside_government_related? ? ["new_feature_request"] : ["new_need_request"]
    specific_tag + inside_government_tag_if_needed
  end

  protected
  def comment_snippets
    [ 
      CommentSnippet.new(on: @request,                 field: :formatted_request_context,
                                                       label: "Which part of GOV.UK is this about?"),
      CommentSnippet.new(on: @request,                 field: :user_need),
      CommentSnippet.new(on: @request,                 field: :url_of_example),
      CommentSnippet.new(on: @request.time_constraint, field: :time_constraint_reason)
    ]
  end
end