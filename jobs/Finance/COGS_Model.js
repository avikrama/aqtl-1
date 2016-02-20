var 
	path = require('path'),
	extract = require('./../../extract').extract,
	transform = require('./../../transform').transform,
	load = require('./../../load').load,
	db = 'finance', // crostoli or finance
	file = path.basename(__filename.replace(/.js$/,'')),
  folder = __dirname.split(path.sep).pop()
	; 

extract(db, folder, file, function(data){
	transform(data, function(data){
		load(data, folder, file);
	});
});

