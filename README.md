FoosNet is a fooseball ranking system. It began development as a Rally Software Development hack-a-thon project.

To get started:
  1. Fork and Clone the repo
  2. `cd foos-net`
  3. Install Node: `brew install -g node`
  4. Install and start MongoDB:
    1. `brew install -g mongodb`
    2. `mongod`
  5. Resolve dependencies: `npm install`
  6. Start up the server: `node server`
  7. Point your browser to `localhost:8080`

To run the tests:
  1. Install jake: `sudo npm install jake -g`
  2. Run tests: `jake spec:node`
