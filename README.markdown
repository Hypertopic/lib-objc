# Hypertopic Objective C Library

Hypertopic Objective C Library is a framework implements Hypertopic V2
protocol to interact with Hypertopic server which is hosted on CouchDB server.

## Changes

### 2011-01-31

* Created Hypertopic objects (User, Corpus, Item, Viewpoint, Topic).
* Implemented a cache for caching HTTP requests.
* Implemented a HTTP watcher for listening CouchDB changes.
* Implemented a series of unit tests for testing Hypertopic framework.

### 2011-01-22

* Created project on github and imported the empty project.
* Importd readme and license file.

## TODO

* Need to check memory leak. Release all object after used.
* Write the API specification.

## Installation

Hypertopic Objective C Library use [JSON.framework](http://github.com/stig/json-framework), follow the following 
steps to link JSON.framework into our project.

1. Download JSON.framework and open it (JSON.codeproj) file with Xcode.
1. Open Hypertopic Objective C Library with Xcode.