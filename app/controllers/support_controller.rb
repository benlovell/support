require "zendesk_request"
require "zendesk_client"
require "guard"

class SupportController < ApplicationController
  def amend_content
    if request.method == "GET"
      on_get("Content Change", "content/content_amend_message", "content/amend")
    elsif request.method == "POST"
      @header = "Content Change"
      @header_message = "content/content_amend_message"
      @template = "content/amend"

      @errors = Guard.validationsForAmendContent(params)
      on_post(params, "amend-content")
    end
  end

  def landing
    render :landing, :layout => "layout"
  end

  private

  def on_get(head, head_message_form, template)
    @client = ZendeskClient.get_client(logger)
    @organisations = ZendeskRequest.get_organisations(@client)
    @header = head
    @header_message = head_message_form
    @formdata = {}

    render :"#{template}", :layout => "formlayout"
  end

  def on_post(params, route)
    @client = ZendeskClient.get_client(logger)
    @organisations = ZendeskRequest.get_organisations(@client)
    @formdata = params

    if @errors.empty?
      ticket = ZendeskRequest.raise_zendesk_request(@client, params, route)
      if ticket
        redirect '/acknowledge'
      else
        500
      end
    else
      render :"#{@template}", :layout => "formlayout"
    end
  end
end