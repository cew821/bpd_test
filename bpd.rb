require 'json'
require 'httparty'

credentials = YAML::load_file(File.join(__dir__, 'config.yml'))

puts credentials["BPD_USER_NAME"]
puts credentials["BPD_API_KEY"]

url = "https://be-denali.herokuapp.com/api/v1/analyze/peers/"

payload = {
    'filters' => {
        'state' => ['CA', 'IL' 'OR'],
        'facility-type' => ['Retail - Big Box (> 50K sf)']
    },
    'number_of_bins' => 25
}

headers = {
    "Content-Type" => "application/json", 
    "Authorization" => "ApiKey #{ credentials["BPD_USER_NAME"] }:#{ credentials["BPD_API_KEY"] }"
}

response = HTTParty.post(
    url,
    :body => payload.to_json,
    :headers => headers
)
puts response