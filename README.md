## API code of the kakuzei.com website using the Rails framework ![build](https://github.com/kakuzei/rails.kakuzei.com/workflows/CI%20Pipeline/badge.svg)

### Introduction

api.kakuzei.com provides a REST API for accessing pictures.

### Requirements

* Docker
* Ruby 3.4.4 with bundler

### Quickstart

##### Install the Ruby dependencies

Install the Ruby dependencies by executing the following command:

```bash
bundle install
```

##### Setup the Database with Sample Data

Load a sample of pictures with tags by executing the following command:

```bash
bundle exec rake kakuzei:init
```
* it creates the datamodel,
* it imports the pictures definition from the data/pictures.yml file,
* it imports the tags definition from the data/tags.yml file.

##### Start the Server

Start the server by executing the following command:

```bash
bundle exec falcon
```

### Docker

##### Build the image

Build a docker image by executing the following command:

```bash
docker build -t kakuzei/api.kakuzei.com .
```

##### Start the container

Start the REST API by executing the following command:

```bash
docker run -d -p 9292:9292 kakuzei/api.kakuzei.com
```

You can use a custom data folder using the --mount argument:

```bash
docker run -d -p 9292:9292 --mount type=bind,source=./data,target=/app/data --env SECRET_KEY_BASE=secret kakuzei/api.kakuzei.com
```

### Development

##### Unit Testing

Execute the unit tests by executing the following command:

```bash
bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake spec
```

### License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.
