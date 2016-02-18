var fs 				= require('fs')
	;

/* Helper functions */
var boolean_search = function(search_term, test){
	try {
		return ~test.indexOf(search_term) ? true : false;
	} catch	(e) {
		return false;
	}
};

var regex_search = function(search_term, test){
	var re = new RegExp(search_term,'i');
	return re.test(test) ? true : false;
};

var parse = function(line, start, finish) {
	var tempArray = []
		,	parsed = [];

	for (i = start; i < finish; i++) {
		tempArray.push(line[i]);
		parsed = tempArray.join('');
	}
	return parsed.trim();
};

var isNegative = function(chr){
	return chr === '-' ? true : false;	
};






/* Export functions */
exports.parse 						= parse;
