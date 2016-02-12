var 
	path = require('path'),
	extract = require('./../extract').extract,
	transform = require('./../transform').transform,
	load = require('./../load').load,
	file = path.basename(__filename.replace(/.js$/,'')),
	db = require('./../lib/config/source_db.js')
	; 

extract(db, file, function(data){
	transform(data, function(data){
		load(data, file);
	});
});

