/**
 * Backbone.js models and collections to represent the system
 */

var User = Backbone.Model.extend({
	defaults : {
		fname: '',
		sname: ''
    }
});

var Task = Backbone.Model.extend({
	defaults : {
		type: 'A',
	    description: '',
	    priority: 1
    }
});

var ErrorMessage = Backbone.Model.extend({
	defaults : {
		severity: 'info',
		msg: ''
    }
});

var TaskList = Backbone.Collection.extend({
	model: Task
});

var ErrorMessageList = Backbone.Collection.extend({
	model : ErrorMessage
});
