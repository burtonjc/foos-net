# FoosNet [![Build Status](https://travis-ci.org/burtonjc/foos-net.png?branch=master)](https://travis-ci.org/burtonjc/foos-net)
FoosNet is a fooseball ranking system. It began development as a Rally Software Development hack-a-thon project.

##Getting started
  1. Fork and Clone the repo
  2. `cd foos-net`
  3. Install Node: `sudo npm install -g node`
  4. Install Jake: `sudo npm install -g jake`
  5. Install sass: `gem install sass`
  6. Resolve node dependencies: `npm install`
  7. Install and start MongoDB:
    1. `brew install -g mongodb`
    2. `jake db:start`
  8. Build the project and start up the server: `grunt build node:run`
  9. Point your browser to the location specified in the otput from the command in number 7

##Testing
You can run all server side tests through grunt with the `grunt test:node` command. If you are actively working on server side code, you can also use `grunt test:node:watch` to run the tests on every code change.
