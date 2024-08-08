/**
 * Javascript for main.html
 */
var TemplateManager = (function() {
	var __templates = {};
	/**
	 * Get the template from the cache or load it synchronously over AJAX
	 */
	this.get = function(id) {
		if (!(id in __templates)) {
			$.ajax({
					url : "templates/" + id + ".txt",
					async : false,
					success: function(tmpl) {
						__templates[id] = tmpl;
					},
					error: function() {
						alert("Error loading template '" + id + "'");
					}
			});
		}
		var template = __templates[id];
		return template;
	};
	/** 
	 * Allows for caching of multiple templates in parallel
	 * Returns a JQuery promise which can be used to execute code when the code is done
	 */
	this.cache = function(list) {
		var retCount = 0;
		var deffered = [];
		for (var i = 0; i < list.length; i++) {
			// Anonymous function as var's are scoped to their parent function no the parent {}
			(function(id) {
				if (!(id in __templates)) {
					deffered.push($.ajax({
							url : "templates/" + id + ".txt",
							success: function(tmpl) {
								__templates[id] = tmpl;
							},
							error: function() {
								alert("Error loading template '" + id + "'");
							}
					}));
				}
			})(list[i]);
		}
		return $.when.apply(null, deffered);
	}
	return this;
}).call({});

