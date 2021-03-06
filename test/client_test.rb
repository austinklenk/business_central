require 'test_helper'

class BusinessCentral::ClientTest < Test::Unit::TestCase
  PATH = "https://api.businesscentral.dynamics.com/v1.0/cronos.com/api/v1.0"

  def test_initialize
    client = bc_client

    assert_not_nil client
    assert_equal "cronos.com", client.api_tenant
    assert_equal "foo", client.api_username
    assert_equal "bar", client.api_password
  end

  def test_base_url
    client = bc_client

    assert_equal "#{PATH}", client.base_url
  end

  def test_base_url_with_company_id
    client = BusinessCentral::Client.new({
      api_tenant: "cronos.com",
      api_username: "username",
      api_password: "password",
      api_host: "https://api.businesscentral.dynamics.com",
      test_mode: true,
      api_company_id: "123456789",
      api_version: "/v1.0",
      api_path: "/api/v1.0"
    })

    assert_equal "#{PATH}/companies(123456789)", client.base_url
    assert_equal "cronos.com", client.api_tenant
    assert_equal "username", client.api_username
    assert_equal "password", client.api_password
    assert_equal "123456789", client.api_company_id
    assert_equal "/v1.0", client.api_version
    assert_equal "/api/v1.0", client.api_path
  end

  test "should perform a get request" do
    client = bc_client

    client.expects(:perform_request).at_least_once
    client.get("/customers")
  end

  test "should perform a post request" do
    client = bc_client

    client.expects(:perform_request).at_least_once
    client.expects(:build_request).at_least_once
    client.post("/customers", { displayName: "FooBar" })
  end

  test "should perform a patch request" do
    client = bc_client

    client.expects(:perform_request).at_least_once
    client.expects(:build_request).at_least_once
    client.patch("/customers(1234)", "etag", { displayName: "FooBar" })
  end

  test "should perform a delete request" do
    client = bc_client

    client.expects(:perform_request).at_least_once
    client.expects(:build_request).at_least_once
    client.delete("/customers(1234)", "etag")
  end
end
