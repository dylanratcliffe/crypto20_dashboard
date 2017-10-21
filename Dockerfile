FROM starefossen/ruby-node:latest

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install -j 8

COPY . /app

EXPOSE 3030

CMD ["bundle", "exec", "smashing", "start", "--debug", "2>&1"]
