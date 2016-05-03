# Time server

[![Build Status](https://travis-ci.org/hrom512/time_server.svg?branch=master)](https://travis-ci.org/hrom512/time_server)
[![Code Climate](https://codeclimate.com/github/hrom512/time_server/badges/gpa.svg)](https://codeclimate.com/github/hrom512/time_server)
[![Test Coverage](https://codeclimate.com/github/hrom512/time_server/badges/coverage.svg)](https://codeclimate.com/github/hrom512/time_server/coverage)

Simple application, which show time in different time zones.

It use [eventmachine](https://github.com/eventmachine/eventmachine) and [evma_httpserver](https://github.com/eventmachine/evma_httpserver) for maximal performance and concurrency.

## Installation

```
$ bundle install
```

## Usage

Run server with command:

```
$ bin/server start
```

Make request by URL [http://localhost:8181/time?Moscow,New%20York](http://localhost:8181/time?Moscow,New%20York)
