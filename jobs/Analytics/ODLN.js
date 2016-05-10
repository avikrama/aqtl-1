var 
	path = require('path'),
  flag = (process.argv[2] ==='-f') ? true : false,	
	extract = 	flag ? require('./../../../extract').extract 			: require('./../../extract').extract,
	transform = flag ? require('./../../../transform').transform 	: require('./../../transform').transform,	
	load = 			flag ? require('./../../../load').load 						: require('./../../load').load,		
	db = 'finance', // crostoli or finance
	html = false, // results as a formatted HTML table?
	file = path.basename(__filename.replace(/.js$/,'')),
	dir = __dirname.split(path.sep),
  folder = flag ? dir[dir.length-2] : dir.pop() ,
  subfolder = flag ? subfolder = dir.pop() : null
	; 

extract(db, folder, file, subfolder, function(data){
	transform(data, function(data){
		load(data, folder, file, subfolder, html);
	});
});


