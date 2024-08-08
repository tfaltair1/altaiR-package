requirejs({
	paths:{
		wps:"/kernelspecs/wps/js"
	}
});
define(
function(require) {
	var Jupyter = require('base/js/namespace');
	var notebook;
	if (Jupyter!=null) {
		notebook = Jupyter.notebook;
	}
 	return {
		onload: function() {
			require('kernelspecs/wps/js/wps');	
			notebook.set_codemirror_mode("wps5.23");
		}
	};
});
