FoosNet is a fooseball ranking system. It began development as a Rally Software Development hack-a-thon project.

To get started:
  1. Clone the repo
  2. `brew install -g node #Install Node`
  2. Install and start MongoDB:
    1. `brew install -g mongodb`
    2. `mongod`
  2. `cd foos-net`
  3. `npm install #Resolve dependencies`
  4. `node server #Start up the server`
  5. Point your browser to `localhost:8080`

To run the tests:
  1. `sudo npm install jake -g #Install jake`
  2. `jake spec:node`
