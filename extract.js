var 
	fs = require('fs')		
	, path = require('path')
	,	data = ''
	;

var extract = function(db, folder, file, cb){
	loadQuery(db, folder, file, cb);
};

var loadQuery = function(db, folder, file, cb) {
	var sqlFile = fs.createReadStream(path.join('./sql'+folder,file+'.sql'));
	console.log(sqlFile);
	sqlFile.on('data',function(chunk){data+=chunk;});
	sqlFile.on('end',function(){
		executeQueryPostgres(db, data, cb);		
	});
};

var executeQueryPostgres = function(db, sql, cb) {
	db.connect(function(err){
		db.query(sql, function(err,result){
			if (err) console.log(err);
			console.log(result);
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

