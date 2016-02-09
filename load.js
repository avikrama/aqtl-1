var 
	fs = require('fs')
	, path = require('path')
	, psql = require('./lib/config/destination_db.js')
	;

var table = 'company';
var sql = 'insert into '+table+'('+
    ' PlatformId, AccountId, Name '+ 
    ' ) values ($1,$2,$3)';

var load = function(data, cb){
	insert(data);
};

var insert = function(data, cb){
	psql.connect();
	data.map(function(item,index){
		psql.query(sql, item, function(err,result){
			console.log(sql,item);
			if(err) console.log(err);
		});
	});
};

exports.load = load;


