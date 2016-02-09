var 
	fs = require('fs')		
	, path = require('path')
	, f = require('./lib/format.js')
	;

var transform = function(data, cb){
	ojbtoarray(data, cb);
};

var ojbtoarray = function(data, cb) {
	var arr = [];

	for(var record in data){ if (data.hasOwnProperty(record)){ // (records as objects) data[record]

		var nested_array = [];
		
		for(var item in data[record]){ if(data[record].hasOwnProperty(item)){ // (key)item : (values)data[record][item] 
			
				nested_array.push( data[record][item] );

		}	}	

		arr.push(nested_array);
	}	}

	cb(arr);
};

// var transform = function(data, cb){
// 	for(var record in data){ if (data.hasOwnProperty(record)){ // (records as objects)data[record]
// 		for(var item in data[record]){ if(data[record].hasOwnProperty(item)){ // (key)item : (values)data[record][item] 
// 			if (f.isDate(data[record][item])) { // format date
// 				data[record][item] = f.formatDate(data[record][item]);
// 			}

// 			if ( ( !f.isDateColumn(item) ) && ( !f.isExcludeColumn(item) ) && ( !isNaN(parseFloat(data[record][item])) ) && ( !f.hasPercentString(data[record][item]) ) ) { // format numbers
// 				data[record][item] = f.formatNumber(parseInt(data[record][item]));
// 			}	}
// 		}	}
// 	}
// 	cb(data);
// };

exports.transform = transform;

