require "test_helper"
require "vcr"
require "open-uri"
require "JSON"
require "pry"

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

class PocketTest < ActiveSupport::TestCase
  attr_accessor :body
	setup do
    VCR.use_cassette('items') do
      @user = users(:one)
      def @user.options
        token = self.token
        consumer_key = ENV['POCKET_KEY']
        
        @options = {
          :access_token => token,
          :consumer_key => consumer_key,
          :detailType   => "complete",
          :count        => 15
         }    
      end
      # binding.pry
      @response = @user.retrieve
      @body = JSON.parse(@response.body)
    end
  end

  test "should get pocket api link" do
  	assert_equal "https://getpocket.com/v3/", @user.url_base
  end

  test "user should be pocket class" do
    assert_equal "Pocket", @user.class.name
  end

  test "should retrieve pocket list" do
    assert_equal @body["status"], 1
  end

  test "should choose items that are in users list and aren't tagged keep" do
    VCR.use_cassette('items') do
      list = @body["list"]
      # puts Benchmark.measure { @user.to_archive }
      expected_list = @user.to_archive
      # binding.pry
      date = Date.today - 7
      ap date = date.to_time.to_i
      
      expected_list.each do |item|
        puts list[item]["time_added"]
        assert_not_nil   list[item]
        assert_equal     list[item]["status"], "0"
        assert_nil       list[item]["tags"].try(:[], "keep")
        assert_operator  list[item]["time_added"].to_i, :<, date
      end 
    end
  end

  # test "should archive list" do
  # 	VCR.use_cassette('archive') do
  #     # archive = {:ac=> {}}
  #     ap results = @user.archive

  #     results.each do |result|
  #       assert_equal 
  #     end
  #   end
  # end

  test "should add count parameter" do
    assert_not_nil @user.options[:count]
    assert_equal 15, @user.options[:count] 
  end

end