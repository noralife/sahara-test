require 'capybara/rspec'
require 'selenium-webdriver'
require 'uri'
require 'net/http'
require 'pry'

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

module SaharaAPI
  def get(host_url, endpoint, headers = {})
    uri          = URI.parse(host_url + endpoint)
    http         = Net::HTTP.new(uri.host, uri.port)
    request      = Net::HTTP::Get.new(uri.request_uri, headers)
    raw_response = http.request(request)
    JSON.parse(raw_response.body)
  end

  def post(host_url, endpoint, data, headers = {})
    uri      = URI.parse(host_url + endpoint)
    http     = Net::HTTP.new(uri.host, uri.port)
    request  = Net::HTTP::Post.new(uri.request_uri, headers)
    request.set_form_data(data)
    raw_response = http.request(request)
    JSON.parse(raw_response.body)
  end

  def put(host_url, endpoint, data, headers = {})
    uri      = URI.parse(host_url + endpoint)
    http     = Net::HTTP.new(uri.host, uri.port)
    request  = Net::HTTP::Put.new(uri.request_uri, headers)
    request.set_form_data(data)
    raw_response = http.request(request)
    JSON.parse(raw_response.body)
  end

  def delete(host_url, endpoint, data, headers = {})
    uri      = URI.parse(host_url + endpoint)
    http     = Net::HTTP.new(uri.host, uri.port)
    request  = Net::HTTP::Delete.new(uri.request_uri, headers)
    request.set_form_data(data) unless data.empty?
    raw_response = http.request(request)
    JSON.parse(raw_response.body)
  end

  def token(email, password)
    post(SAHARA_CMS_URL, '/api/v1/login', 'email' => email, 'password' => password)['token']
  end

end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include Capybara::DSL
  config.include WaitForAjax
  config.include SaharaAPI
end

Capybara.default_driver = :selenium
Capybara.app_host = ENV['SAHARA_URL'] || 'http://localhost:3000'
Capybara.default_max_wait_time = 5

SAHARA_CMS_URL = ENV['SAHARA_CMS_URL'] || 'http://localhost:3000' 
SAHARA_PMS_URL = ENV['SAHARA_PMS_URL'] || 'http://localhost:3000'
SAHARA_OMS_URL = ENV['SAHARA_OMS_URL'] || 'http://localhost:3000'
