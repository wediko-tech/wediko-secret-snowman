# Wediko Secret Snowman

An application that handles secret snowman and other wishlist-based events for the nonprofit Wediko

## Local setup
* Clone the repository to your machine with `git clone`
* Install phantomjs to run Javascript tests by running `npm install -g phantomjs-prebuilt`
* Install dependencies with `bundle install`
* Set up the database with `bundle exec rake db:setup`

## Running the server locally
* Start sidekiq with `bundle exec sidekiq`
* Start redis with `redis-server`
* Start the server locally with `bundle exec rails s`
* Navigate to `http://localhost:3000` to explore the site.

## Pushing to production
* This is done by running a deploy of the `secret-snowman-prod` app on the ID8 Wediko - Production stack in AWS OpsWorks.
* Servers must be online to push to them.
* Once the server is online/deployed, you can access it at `http://wediko.steve-pletcher.com`

### Troubleshooting
If a deploy fails due to being unable to fetch a cookbook, you may need to update the cookbooks we use to deploy Sidekiq instances by running an `update_custom_cookbooks` or `update_dependencies` action on the running instances.
