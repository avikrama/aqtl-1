var 
	fs = require('fs')		
	, path = require('path')
	,	data = ''
	;

var extract = function(db, file, cb){
	loadQuery(db, file, cb);
};

var loadQuery = function(db, file, cb) {
	var sqlFile = fs.createReadStream(path.join('./../sql',file+'.sql'));
	sqlFile.on('data',function(chunk){data+=chunk;});
	sqlFile.on('end',function(){
		executeQueryPostgres(db, data, cb);		
	});
};

var executeQueryPostgres = function(db, sql, cb) {
	db.connect(function(err){
		db.query(sql, function(err,result){
			if (err) console.log(err);
			cb(result.rows);
		});	
	});
};

var executeQueryMSSQL = function(db, sql, cb) {
	// var connection 	= new mssql.Connection(db_config, function(err) {
	// 	if (err) console.log(err);
	// 	var r = new mssql.Request(connection);
	// 	r.query(sql, function(err, results){
	// 		if (err) console.log(err);
	// 		cb(results);
	// 	});
	// });
};

exports.extract = extract;

