## Build Rails Image
 `docker build --tag rails-app:1.0.0`

## Run docker compose
`docker-compose up`

## Run db:setup

`docker-compose exec rails_app rake db:setup`