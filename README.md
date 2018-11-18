## Rails server for kakuzei.com website [![Build Status](https://travis-ci.org/kakuzei/rails.kakuzei.com.svg?branch=master)](https://travis-ci.org/kakuzei/rails.kakuzei.com) [![Maintainability](https://api.codeclimate.com/v1/badges/29fdfd4cc3f516610ea4/maintainability)](https://codeclimate.com/github/kakuzei/rails.kakuzei.com/maintainability)

### Introduction

rails.kakuzei.com provides a REST API for accessing pictures.

### Requirements

* Ruby 2.5.3 with Bundler

### Quickstart

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
bundle exec puma
```

### Docker

##### Build the image

Build a docker image by executing the following command:

```bash
docker build -t kakuzei.com/rails .
```

##### Start the container

Start the REST API by executing the following command:

```bash
docker run -d -p 3000:3000 kakuzei.com/rails
```

You can use a custom data folder using the --mount argument:

```bash
docker run -d -p 3000:3000 --mount type=bind,source=/custom/data,target=/app/data kakuzei.com/rails
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
