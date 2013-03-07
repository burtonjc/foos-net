namespace('spec', function() {
    desc('Run node server specs.');
    task('node', [], function() {
        var spec_root = 'spec/',
            setup = spec_root + 'SpecSetup.js';

        console.log("\nRunning node specs:");
        jake.exec('jasmine-node --color --coffee --requireJsSetup ' + setup + ' ' + spec_root, function() {
            console.log("tests are finished.");
            complete();
        }, {
            printStdout: true,
            printStderr: true
        });
    });
});