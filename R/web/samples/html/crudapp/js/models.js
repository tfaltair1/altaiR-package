/**
 * Backbone.js models and collections to represent the system
 */

var ErrorMessage = Backbone.Model.extend({
	defaults : {
		severity: 'info',
		msg: ''
    }
});

var Cat = Backbone.Model.extend({
});

var CatList = Backbone.Collection.extend({
	model: Cat
});

var ErrorMessageList = Backbone.Collection.extend({
	model : ErrorMessage
});

var DatatableRow = Backbone.Model.extend({
});

var DatatableList = Backbone.Collection.extend({
	model: DatatableRow
});
