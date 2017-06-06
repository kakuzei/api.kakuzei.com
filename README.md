## Rails server for kakuzei.com website

### Introduction

rails.kakuzei.com provides a REST API for accessing pictures.

### Requirements

* Ruby 2.3.3 with bundler

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
 
 
### License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.