/**
 * Graph controls
 *
 */


var GraphView = Backbone.View.extend({
	initialize : function(options) {
		this.__baseUrl = options.baseUrl;
		this.__additionalParameters = options.additionParameters;
	},
	render: function() {
	    var src = this.__baseUrl;
		if (this.__additionalParameters) {
			src += "&" + $.param(this.__additionalParameters(), true);
		}
        this.$el.attr('src', '');
		src += "&___=" + new Date().getTime(); // Forces IE to reload image
        this.$el.attr('src', src);
	}
 });
