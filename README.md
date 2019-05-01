# LiteXBRL

LiteXBRLはXBRLパーサです。

#### サポート
- TDnet
  - 短信サマリ（日本会計基準・米国会計基準・IFRS）

## Installation

Add this line to your application's Gemfile:

    gem 'litexbrl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install litexbrl

## Usage

    require "litexbrl"
    require "pp"

    file = "tse-acedjpsm-27510-20160610419900-ixbrl.htm"
    pp LiteXBRL::TDnet.parse file

    =>  {:summary=>
          {:code=>"2751",
           :year=>2016,
           :month=>4,
           :quarter=>4,
           :net_sales=>27111,
           :consolidation=>1,
           :operating_income=>2014,
           :ordinary_income=>2126,
           :net_income=>1166,
           :net_income_per_share=>98.59,
           :change_in_net_sales=>0.149,
           :change_in_operating_income=>0.095,
           :change_in_ordinary_income=>0.135,
           :change_in_net_income=>0.338,
           :prior_net_sales=>23594,
           :prior_operating_income=>1839,
           :prior_ordinary_income=>1873,
           :prior_net_income=>871,
           :prior_net_income_per_share=>73.96,
           :change_in_prior_net_sales=>0.271,
           :change_in_prior_operating_income=>0.366,
           :change_in_prior_ordinary_income=>0.208,
           :change_in_prior_net_income=>0.026},
         :results_forecast=>
          [{:code=>"2751",
            :year=>2017,
            :month=>4,
            :quarter=>4,
            :consolidation=>1,
            :forecast_net_sales=>28000,
            :forecast_operating_income=>2150,
            :forecast_ordinary_income=>2255,
            :forecast_net_income=>1000,
            :forecast_net_income_per_share=>83.92,
            :change_in_forecast_net_sales=>0.033,
            :change_in_forecast_operating_income=>0.067,
            :change_in_forecast_ordinary_income=>0.06,
            :change_in_forecast_net_income=>-0.143}]}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
