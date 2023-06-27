require "test_helper"

class TxnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @txn = txns(:one)
  end

  test "should get index" do
    get txns_url, as: :json
    assert_response :success
  end

  test "should create txn" do
    assert_difference("Txn.count") do
      post txns_url, params: { txn: {  } }, as: :json
    end

    assert_response :created
  end

  test "should show txn" do
    get txn_url(@txn), as: :json
    assert_response :success
  end

  test "should update txn" do
    patch txn_url(@txn), params: { txn: {  } }, as: :json
    assert_response :success
  end

  test "should destroy txn" do
    assert_difference("Txn.count", -1) do
      delete txn_url(@txn), as: :json
    end

    assert_response :no_content
  end
end
