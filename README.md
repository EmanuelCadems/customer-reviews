# README

[![GitHub version](https://badge.fury.io/gh/EmanuelCadems%2Fcustomer-reviews.svg)](https://badge.fury.io/gh/EmanuelCadems%2Fcustomer-reviews)
[![Build Status](https://travis-ci.com/EmanuelCadems/customer-reviews.svg?branch=master)](https://travis-ci.com/EmanuelCadems/customer-reviews)
[![Maintainability](https://api.codeclimate.com/v1/badges/7489ae08985b69937a91/maintainability)](https://codeclimate.com/github/EmanuelCadems/customer-reviews/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/EmanuelCadems/customer-reviews/badge.svg?branch=master)](https://coveralls.io/github/EmanuelCadems/customer-reviews?branch=master)

This is an API about CustomerReview. You can find the full description inside specs.

You can check the [documentation](https://stark-mesa-90873.herokuapp.com/docs/) and start using this API with the Online version instead of installing this app in your local machine.


For the documentation use the proper API_KEYs that you received in your email along with the full description of the API.


## Ruby version


2.5.1

Are you using rvm?

run:
```bash
  $ cd .
```
This will select the ruby version and will also create a gemset called qaa.

## System dependencies
  Postgresql 9.4

## Configuration


Install bundler with:
```bash
  $ gem install bundler -v='1.16.4' --no-rdoc --no-ri
```
Then install all dependencies with
```bash
  $ bundle install
```

Create your `config/application.yml` and fill it with the required environment variables.
```bash
  $ cp config/application.yml.example config/application.yml
```

## Database creation
```bash
  $ rake db:create
```

## Database initialization
```bash
  $ rake db:migrate
```

## Start the server
```bash
  $ rails s
```
It stats on `http://localhost:3000`
Go to the doc `http://localhost:3000/docs`
Copy the curl command obtained from the documentation and paste in Postman.
Change the domain with `http://localhost:3000` if you are trying in your localhost
Remember to use the right API_KEYS in each case: `USER_API_KEY`, `MODERATOR_API_KEY`, and `ADMIN_API_KEY`
They are setted in `config/application.yml`

You can also play online with heroku using the endpoint specified in the documentation.

## How to run the test suite
This project use rspec. You can run the tests with:
```bash
  $ bundle exec rspec
```
You can see the coverage with:
```bash
  $ open coverage/index.html
```


## Generate doc

Geenerate doc with:

```bash
$ rake docs:generate
$ open doc/api/index.html
```

## Check quality and maintenance of code


The following task will run differents tools for checking quality, maintenance, and security in this code.


```sh
  rake code:check
```


You can also run these tools manually


```sh
  rubucop .
```


```sh
  rails_best_practices .
```


```sh
  brakeman .
```


And so on..


## Deploy

Deploy to heroku with:

```bash
  $ git push heroku master
```

Upload environment variables to heroku with:

```bash
  $ figaro heroku:set -e production
```

Check environment variables with

```bash
  $ heroku config
```


