var 
	fs = require('fs')
	, path = require('path')
	, csv = require('fast-csv')
	, email	= require('emailjs')
	, emailconfig = require('./lib/config/email.js')
	, distro 	= require('./lib/distribution.js')
	, f = require('./lib/format.js')
	, server 	= email.server.connect(emailconfig)
	, fileDir = './../csv'
	;

var load = function(data, file) {
	saveCSV(data, file, function(){
		email(data, file);
	});
};

var saveCSV = function(data, file, cb) {
	var outFile 		= path.join(fileDir, file + '.csv');

	csv.writeToPath(outFile, data, {headers: true})
	.on('finish', function(){
		cb(data, file);
	});
};

var email = function(data, file){
	f.generateTableJSON(data, file, function(table){
		composeEmail(table, file, function(message){
			sendEmail(message);
		});
	});
};

var composeEmail = function(table, file, cb){
	var now = new Date();
	var arr = ['Automated report generated on: '+now.toString().slice(0,21), // body
		distro[file], // distro
		file +' : Yapstone BI Reports', // subject
		file+'.csv' // attachment
	];

	var text = arr[0], to = arr[1], subject = arr[2], attachment = arr[3];

	var message = {
		text: text,
		from: 'John Skilbeck jskilbeck@yapstone.com',
		to: 	to,
		subject: subject,
		attachment: [
			{ data: '<html><body><p>'+text+'</p><br />'+table+'</body></html>', alternative:true},
			{ path: path.join(fileDir,attachment), type: 'text/csv', name: attachment	}
		]
	};

	cb(message);
};

var sendEmail = function(message){
	server.send(message, function(err, message){
		console.log(err || message);
	});
};

exports.load = load;


