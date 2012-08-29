require 'bundler'
Bundler.require

require "yaml"

class ZendeskClient

  def self.get_username_password(config_details)
    environment = ENV['GOVUK_ENV'] || "development"
    [config_details[environment]["username"].to_s, config_details[environment]["password"].to_s]
  end

  @client = ZendeskAPI::Client.new { |config|
    file = YAML::load_file(File.open('./config/zendesk.yml'))
    login_details = self.get_username_password(file)
    config.url = "https://govuk.zendesk.com/api/v2/"
    config.username = login_details[0]
    config.password = login_details[1]
  }

  def self.get_departments
    departments_hash = {"Select Department" => ""}
    @client.ticket_fields.find(:id => '21494928').custom_field_options.each { |tf| departments_hash[tf.name] = tf.value }
    departments_hash
  end

  def self.raise_zendesk_request(subject, tag, name, email, dep, job, phone, comment, need_by_date, not_before_date)
    phone = remove_space_from_phone_number(phone)
    @client.ticket.create(
        :subject => subject,
        :description => "Created via Govt API",
        :priority => "normal",
        :requester => {"locale_id" => 1, "name" => name, "email" => email},
        :fields => [{"id" => "21494928", "value" => dep},
                    {"id" => "21487987", "value" => job},
                    {"id" => "21471291", "value" => phone},
                    {"id" => "21485833", "value" => need_by_date},
                    {"id" => "21502036", "value" => not_before_date}],
        :tags => [tag],
        :comment => {:value => comment})
  end

  def self.upload_file(path)

    upload = ZendeskAPI::Upload.create(@client, :file => File.open(path))
    upload.token
  end

  def self.create_ticket_with_attachment(subject, tag, name, email, department, job, phone, comment, need_by_date, not_before_date, file_token)
    phone = remove_space_from_phone_number(phone)
    @client.ticket.create(
        :subject => subject,
        :description => "Created via Govt API",
        :priority => "normal",
        :requester => {"locale_id" => 1, "name" => name, "email" => email},
        :fields => [{"id" => "21494928", "value" => department},
                    {"id" => "21487987", "value" => job},
                    {"id" => "21471291", "value" => phone},
                    {"id" => "21485833", "value" => need_by_date},
                    {"id" => "21502036", "value" => not_before_date}],
        :tags => [tag],
        :comment => {:value => comment, :uploads => [file_token]})
  end

  def self.remove_space_from_phone_number(number)
    number.gsub(/\s+/, "")
  end
end
