var 
	fs = require('fs')
	, path = require('path')
	, csv = require('fast-csv')
	, f = require('./lib/helper_js/format.js')
	;

var load = function(data, folder, file, subfolder, html) {
	saveCSV(data, folder, file, subfolder, function(){
		email(data, folder, file, subfolder, html);
	});
};

var saveCSV = function(data, folder, file, subfolder, cb) {
	var outFile = subfolder ?  path.join('./../../../csv', folder, subfolder, file + '.csv') : path.join('./../../csv', folder, file + '.csv');

	csv.writeToPath(outFile, data, {headers: true})
	.on('finish', function(){
		cb(data, file);
	});
};

var email = function(data, folder, file, subfolder, html){
	f.generateTableJSON(data, function(table){
		composeEmail(table, folder, file, subfolder, html, function(message){
			sendEmail(message);
		});
	});
};

var composeEmail = function(table, folder, file, subfolder, html, cb){
	var distro = require('./lib/email/'+folder+'.js');
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
			{ path: subfolder ? path.join('./../../../csv', folder, subfolder, attachment) : path.join('./../../csv', folder, attachment)
				, type: 'text/csv', name: attachment	}
		]
	};

	if (html) {
		message.attachment.push({
			data: '<html><body><p>'+text+'</p><br />'+table+'</body></html>', alternative:true
		});
	}

	cb(message);
};

var sendEmail = function(message){
	var email	= require('emailjs'),
		emailconfig = require('./lib/config/email.js'),
		server 	= email.server.connect(emailconfig)
	;

	server.send(message, function(err, message){
		console.log(err || message);
		process.exit();
	});
};

exports.load = load;


