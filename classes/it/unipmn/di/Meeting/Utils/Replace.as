
String.prototype.replace = function(find, replace, iReplaces) {

	counter = i = 0;

	string = String(this);

	while (counter<string.length) {

		start = string.indexOf(find, counter);

		if (start == -1) {

			break;

		} else {

			before = string.substr(0, start);

			after = string.substr(start+find.length, string.length);

			string = before+replace+after;

			counter = before.length+replace.length;

			i++;

			if (i == iReplaces) counter = string.length;

		}

	}

	return string;

}
