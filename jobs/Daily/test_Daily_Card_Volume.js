var 
	path = require('path'),
  flag = (process.argv[2] ==='-f') ? true : false,	
	extract = 	flag ? require('./../../../extract').extract 			: require('./../../extract').extract,
	transform = flag ? require('./../../../transform').transform 	: require('./../../transform').transform,	
	load = 			flag ? require('./../../../load').load 						: require('./../../load').load,		
	db = 'crostoli', // crostoli or finance
	html = true, // results as a formatted HTML table?
	file = path.basename(__filename.replace(/.js$/,'')),
	dir = __dirname.split(path.sep),
  folder = flag ? dir[dir.length-2] : dir.pop() ,
  subfolder = flag ? subfolder = dir.pop() : null
	; 

var yesterday = new Date(new Date().setDate(new Date().getDate() - 2)).toISOString().slice(0,10);

extract(db, folder, file, subfolder, function(data){
	transform(data, function(data){
		if(data[0][yesterday] !== null){
			load(data, folder, file, subfolder, html);
		}
		console.log(data);
	});
});

