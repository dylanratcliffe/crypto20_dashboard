# CRYPTO20 Dashboard

This dashboard tracks the status of the [CRYPTO20](https://www.crypto20.com) ICO

## Contributing

Pull requests are welcome, to start the dashboard locally you will need to make sure you have [Ruby](https://www.ruby-lang.org/en/downloads/) installed, then:

  1. Make sure you have bundler installed: `gem install bundler`
  1. Clone this repository
  1. `cd` into the repository folder
  1. Run `bundle install` to install dependencies
  1. Run `bundle exec smashing start` to run the dashboard

### Bootstrapping with warm chart data

Most notably, you can use the history.yaml file within Smashing to accomplish this, however we want to quickly copy the 'points' JSON structure from the `/events` endpoint, paste it in a file, build out the doctor container and have it "just work". So, we do so under `bootstrap_data/points.json`.
