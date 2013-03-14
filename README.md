FoosNet is a fooseball ranking system. It began development as a Rally Software Development hack-a-thon project.

To get started:
  1. Fork and Clone the repo
  2. `cd foos-net`
  3. Install Node: `sudo npm install -g node`
  4. Install Jake: `sudo npm install -g jake`
  5. Resolve dependencies: `npm install`
  6. Install and start MongoDB:
    1. `brew install -g mongodb`
    2. `jake db:start`
  7. Start up the server: `jake run:server`
  8. Point your browser to the location specified in the otput from the command in number 7

To run the tests:
  1. Run tests: `jake spec:node`
