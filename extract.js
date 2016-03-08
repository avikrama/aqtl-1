var 
	fs = require('fs')		
	, path = require('path')
	,	data = ''
	;

var extract = function(db, folder, file, subfolder, cb){
	loadQuery(db, folder, file, subfolder,cb);
};

var loadQuery = function(db, folder, file, subfolder, cb) {
	var sqlFile =  subfolder ? fs.createReadStream(path.join('./../../../sql',folder,subfolder,file+'.sql')) : fs.createReadStream(path.join('./../../sql',folder,file+'.sql')) ;
	sqlFile.on('data',function(chunk){data+=chunk;});
	sqlFile.on('end',function(){
		if (db === 'crostoli'){
			executeMSSQL(data, cb);
		} else if (db === 'finance') {
			executePSQL(data, cb);					
		} else if (db === 'localhost') {
			executeLocalhost(data, cb);
		}
	});
};

var executeMSSQL = function(sql, cb) {
	var mssql = require('mssql'),
		db = require('./lib/config/crostoli_db.js')
		;
	var connection 	= new mssql.Connection(db, function(err) {
		if (err) console.log(err);
		var r = new mssql.Request(connection);
		r.query(sql, function(err, results){
			if (err) console.log(err);
			cb(results);
		});
	});
};

var executePSQL = function(sql, cb) {
	db = require('./lib/config/finance_db.js');
	db.connect(function(err){
		db.query(sql, function(err,result){
			if (err) console.log(err);
			cb(result.rows);
		});	
	});
};

var executeLocalhost = function(sql, cb) {
	db = require('./lib/config/localhost_db.js');
	db.connect(function(err){
		db.query(sql, function(err,result){
			if (err) console.log(err);
			cb(result.rows);
		});	
	});
};


exports.extract = extract;

