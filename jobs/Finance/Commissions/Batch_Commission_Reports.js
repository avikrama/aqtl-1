var fs = require('fs'),
	path = require('path'),
	exec = require('child_process').exec
	;

fs.readdir('.', function(err,files){
	return files.map(function(file,iterator){
		if(path.extname(file) == '.js' && file.substring(0,4) === 'Cms_') {
			var fileExec = exec('node '+file+' -f');

			fileExec.stdout.on('data',function(data){
				console.log(data);
			});

			fileExec.stderr.on('data',function(data){
				console.log(data);
			});
		}
	});
}); 