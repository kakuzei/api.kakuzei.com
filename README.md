## Rails server for kakuzei.com website ![build](https://github.com/kakuzei/rails.kakuzei.com/workflows/build/badge.svg)

### Introduction

rails.kakuzei.com provides a REST API for accessing pictures.

### Requirements

* Docker

### Quickstart

##### Build the ruby-dev Docker image

Build the ruby-dev Docker image by executing the following command:

```bash
docker build -f Dockerfile-dev -t ruby-dev .
```

##### Run a ruby-dev Docker container

Run a ruby-dev Docker container by executing the following command:

```bash
docker run --rm --name rails.kakuzei.com -p 3000:3000 -v %CD%:/app -v bundle:/usr/local/bundle -w /app -it ruby-dev
```

##### Install the Ruby dependencies

Install the Ruby dependencies by executing the following command inside the running container:

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
bundle exec puma
```

### Production

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
