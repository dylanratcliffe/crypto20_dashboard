# CRYPTO20 Dashboard

This dashboard tracks the status of the [CRYPTO20](https://www.crypto20.com) ICO

## Running the Dashboard

The C20 dashboard consists of three parts: frontend, ingestor and database. All parts are distributed as docker containers. In order to spin up the dashboard locally you will need [Docker](https://www.docker.com/) installed. Follow these steps to set it up:

Start the mongodb container:

```
docker run -d -p 27017:27017 -v ~/data:/data/db mongo
```

Where `~/data` is the path on your machine where data will be stored.

Once the database is running, start the [ingestor service](https://github.com/dylanratcliffe/crypto20_ingestor) by cloning the repository, running `bundle install`, then running:

```
bundle exec ruby ingest.rb
```

This will update values every three seconds and add historical data every 10min. In order for the graph and bubble chart to display you will need at least two historical data points so leave this running for a while.

To then run the dashboard, `cd` into the directory where the repo has been cloned, run `bundle install` and then run:

```
bundle exec smashing start
```

This will host the dashboard on `http://localhost:3030`

## Contributing

Pull requests are welcome, to start the dashboard locally you will need to make sure you have [Ruby](https://www.ruby-lang.org/en/downloads/) installed, then:

  1. Make sure you have bundler installed: `gem install bundler`
  1. Clone this repository
  1. `cd` into the repository folder
  1. Run `bundle install` to install dependencies
  1. Run `bundle exec smashing start` to run the dashboard
