desc 'Run Jasmine code examples'
task :jasmine do
	root = Pathname.new(__FILE__).dirname
	spec_root = root + 'spec/'
    setup = spec_root + 'SpecSetup.js'

	fail unless Kernel.system(
		'jasmine-node',
        '--color',
		'--coffee',
		'--requireJsSetup',
		setup.to_s,
		spec_root.to_s
	)
end
