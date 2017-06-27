## Rails server for kakuzei.com website [![Build Status](https://travis-ci.org/kakuzei/rails.kakuzei.com.svg?branch=master)](https://travis-ci.org/kakuzei/remove_duplicate) [![Code Climate](https://codeclimate.com/github/kakuzei/remove_duplicate/badges/gpa.svg)](https://codeclimate.com/github/kakuzei/rails.kakuzei.com)

### Introduction

rails.kakuzei.com provides a REST API for accessing pictures.

### Requirements

* Ruby 2.4.1 with Bundler

### Quickstart

##### Setup the Database with Sample Data

Load a sample of pictures with tags by executing the following command:

```bash
bundle exec rake kakuzei:generate
```
 * it creates the datamodel,
 * it imports the pictures definition from the data/pictures.yml file,
 * it imports the tags definition from the data/tags.yml file.

##### Start the Server

Start the server by executing the following command:

```bash
bundle exec puma
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
