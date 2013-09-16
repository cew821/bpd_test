require 'json'
require 'httparty'
require 'awesome_print'

class BpdAPI
  def initialize
    @credentials = YAML::load_file(File.join(__dir__, 'config.yml'))
    @base_uri = "https://be-denali.herokuapp.com/api/v1/analyze/peers/"
    @headers = headers = { "Content-Type" => "application/json", "Authorization" => "ApiKey #{ @credentials["BPD_USER_NAME"] }:#{ @credentials["BPD_API_KEY"] }" }
  end

  def request(payload)
    response = HTTParty.post(
      @base_uri,
      body: payload.to_json,
      headers: @headers
    )
  end

  def filtered_results(filters)
    payload = { 'filters' => filters }
    request(payload)
  end

  def compare_states(state1, state2, facility_type = 'Retail - Big Box (> 50k sf)')
    puts "Comparing #{state1} to #{state2}, please stand by..."
    first = filtered_results({ 'state' => [state1], 'facility-type' => facility_type })
    second = filtered_results({ 'state' => [state2], 'facility-type' => facility_type })
    first_average =   first['eui_distribution']['mean']
    second_average =  second['eui_distribution']['mean']
    comparision = (first_average / second_average) - 1
    puts "On average, #{state1}'s #{facility_type} buildings are #{comparision.round(2)}% #{better?(first_average, second_average)} energy intensive than #{state2}'s buildings"
  end

  def better?(first, second)
    if first > second
      "more"
    else
      "less"
    end
  end
end

api = BpdAPI.new

api.compare_states('TX','MN')

# api.request(payload)