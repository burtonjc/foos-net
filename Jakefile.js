namespace('spec', function() {
    desc('Run node server specs.');
    task('node', [], function() {
        var spec_root = 'spec/',
            setup = spec_root + 'SpecSetup.js';

        console.log("\nRunning node specs...:");
        jake.exec('jasmine-node --color --coffee --requireJsSetup ' + setup + ' ' + spec_root, null,{
            printStdout: true,
            printStderr: true
        });
    });
});

namespace('run', function() {
    desc('Start mongodb.');
    task('db', [], function() {
        console.log('\nForking a process to run mongodb...');
        jake.exec('mongod --fork', function() {
            complete();
        },{
            printStdout: true,
            printStderr: true,
            async: true
        });
    });

    desc('Start server.');
    task('server', [], function() {
        console.log('\nStarting server...');
        jake.exec('node node/server', function() {
            complete();
        },{
            printStdout: true,
            printStderr: true,
            async: true
        });
    });
});