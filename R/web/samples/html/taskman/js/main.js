/**
 * Namespace for task manager functions
 * @namespace
 */
var taskmanager = {};

taskmanager.checkLogin = function(success, fail) {
	$.ajax({
		url : CONFIG.brokerUrl,
		type: "GET",
		data : $.extend({}, taskmanager.getServerInfo(), {
			_program : "taskman.checklogin.sas"
		}),
		dataType : "json",
		success : function(data) {
			taskmanager.__serverinfo = data;
			success();
		},
		error: function(data) {
			fail(data);
		}
	});
}

taskmanager.logout = function() {
	taskmanager.setServerInfo({});
}

taskmanager.__serverinfo = {};

/**
 * Set the server info used to connect to WPS/Web
 * {
 *   brokerurl
 *   details : {
 *     _sessionid
 *     _server
 *     _port
 *     _service
 *   }
 * }
 */
taskmanager.setServerInfo = function(info) {
	taskmanager.__serverinfo = $.extend({}, info);
}

taskmanager.getServerInfo = function() {
	return $.extend({}, taskmanager.__serverinfo);
}

taskmanager.initResources = function(callback) {
	// Pre-load templates to a cache
	TemplateManager.cache(["task", "tasklist", "userinfo", "error"]).done(function() {
		callback();
	});
}

taskmanager.__sortcol = "priority";

taskmanager.setSortCol = function(c) {
	taskmanager.__sortcol = c;
}

taskmanager.getSortCol = function() {
	return taskmanager.__sortcol;
}

taskmanager.__sortAscending = true;

taskmanager.setSortAscending = function(a) {
	taskmanager.__sortAscending = a;
}

taskmanager.isSortAscending = function() {
	return taskmanager.__sortAscending;
}

taskmanager.__filter = "";

taskmanager.getFilter = function() {
	return taskmanager.__filter;
}

taskmanager.setFilter = function(f) {
	taskmanager.__filter = f;
}

taskmanager.initResources(function() {

	var errorMessages = new ErrorMessageList();


	/// Get account information
	var thisUser = new User();

	/// Get tasks list
	var myTasks = new TaskList();
	function loadTaskList(callback) {
		myTasks.fetch({
			async: false,
			url : CONFIG.brokerUrl,
			data : $.extend({}, taskmanager.getServerInfo(), {
				_program : "taskman.listtasks.sas",
				sortCol : taskmanager.getSortCol(),
				sortAsc : taskmanager.isSortAscending(),
				filter : taskmanager.getFilter()
			}),
			error: function(model, jqXHR) {
				var msg = jqXHR.getResponseHeader("message");
			    if (!msg) {
				    msg = "Unspecified error";
			    }
			    errorMessages.add([{ severity: "err", msg: msg }]);
			},
			success : function() {
				var ic = $("<span></span>");
				ic.addClass("ui-icon");
				if (taskmanager.isSortAscending()) {
					ic.addClass("ui-icon-triangle-1-n");
				} else {
					ic.addClass("ui-icon-triangle-1-s");
				}
				var th = $("#tasklisttable").find("a[data-colname='" + taskmanager.getSortCol() + "']").parent();
				th.prepend(ic);
				if (callback) {
					callback();
				}
		    }
		});
	}

	/// Render
	var ErrorView = Backbone.View.extend({
		render: function() {
			var variables = {
				severity : this.model.get('severity'),
				msg : this.model.get('msg')
			};
			var template = _.template(TemplateManager.get("error"), variables);
			this.$el.append(template);
		}
	});

	var ErrorListView = Backbone.View.extend({
		initialize: function() {
			this.collection.bind("reset", this.render, this);
			this.collection.bind("add", this.render, this);
			this.collection.bind("remove", this.render, this);
		},
		render: function() {
			this.$el.html("");
			if (this.collection.length > 0) {
				$("#errormessages-holder").show();
				_.each(this.collection.models, function (err) {
					this.renderError(err, this.$el);
				}, this);
			} else {
				$("#errormessages-holder").hide();
			}
		},
		renderError : function(err, elem) {
		  var tv = new ErrorView({el : elem, model: err});
		  tv.render();
		}
	});

	var TaskView = Backbone.View.extend({
		initialize: function() {
			this.render();
		},
		render: function() {
			var variables = {
				id : this.model.id,
				type : this.model.get('type'),
				description : this.model.get('description'),
				priority : this.model.get('priority')
			};
			var template = _.template(TemplateManager.get("task"), variables);
			this.$el.find("tbody").append(template);
		}
	});

	var TaskListView = Backbone.View.extend({
		initialize: function() {
			this.collection.bind("reset", this.render, this);
			this.collection.bind("add", this.render, this);
			this.collection.bind("remove", this.render, this);
		},
		render: function() {
			var template = _.template(TemplateManager.get("tasklist"), {});
			this.$el.html(template);
			var table = this.$el.find("table");
			if (this.collection.length > 0) {
				_.each(this.collection.models, function (task) {
					this.renderTask(task, table);
				}, this);
			} else {
				var $nr = $("<tr></tr>");
				var i = table.find("th").size();
				$nr.append($("<td colspan=\"" + i + "\" class=\"warning noresults\">No results</td>"));
				table.find("tbody").append($nr);
			}

			//  Extra styles
			// http://www.ke-cai.net/2010/01/theme-your-table-with-jquery-ui.html
			table.find("th").each(function() {
				$(this).addClass("ui-state-default");
			});
			table.find("td").each(function() {
				$(this).addClass("ui-widget-content");
			});
			table.find("tr").hover(function() {
					$(this).children("td").addClass("ui-state-hover");
				}, function() {
					$(this).children("td").removeClass("ui-state-hover");
				}
			);
			table.find(".jsbutton").each(function() {
				$(this).button().click(function(event) {
					event.preventDefault();
				});
			});
			table.find("tbody").disableSelection();
		},
		renderTask : function(task, table) {
		  var tv = new TaskView({el : table, model: task});
		}
	});

	var UserView = Backbone.View.extend({
		render: function() {
			var variables = {
				id : this.model.id,
				fname : this.model.get('fname'),
				sname : this.model.get('sname')
			}
			var template = _.template(TemplateManager.get("userinfo"), variables);
			this.$el.html(template);
		}
	});

	// JQuery wrappers for DOM that is always present
	var newTaskDialog = $("#newtaskdialog");
	var newTaskForm = newTaskDialog.find("form");
	var newTaskForm_descripition = newTaskForm.find("[name='txt_description']");
	var loginDialog = $("#logindialog");
	var loginFormFname = loginDialog.find("[name='txt_fname']");
	var loginFormSname = loginDialog.find("[name='txt_sname']");
	var filterControl = $("#filterform [name='filter']");

	// Use JQuery to add event handlers
	$(document).on("click", "#btn-create-new-task", function(event) {
		newTaskDialog.dialog("open");
		return false;
	});
	$(document).on("click", "#btn-logout", function(event) {
		// Don't care if we succeed as we're deleting our session information anyway, but we'll try to inform the server
		// that we're not using the session any more
		$.ajax({
			type: "POST",
			dataType: "json",
			url: CONFIG.brokerUrl,
			data : $.extend({}, taskmanager.getServerInfo(), {
				_program : "taskman.logout.sas"
			})
		});
		taskmanager.logout();
		$("#outer").hide();
		loginDialog.dialog("open");
		loginDialog.find("input").val("");
		return false;
	});
	$(document).on("click", ".jsbutton[data-button-event='delete-task']", function(event) {
		var id = $(this).parent().parent().attr("data-taskid");
		$.ajax({
			url : CONFIG.brokerUrl,
			type: "POST",
			data : $.extend({}, taskmanager.getServerInfo(), {
				_program : "taskman.deletetask.sas",
				id: id
			}),
			dataType : "json",
			complete: function(jqXHR) {
				if (jqXHR.status == 204) {
					loadTaskList();
				} else {
					errorMessages.add([{
						severity: "err",
						msg: "Error deleting task #" + id
					}]);
				}
			}
		});
		return false;
	});
	$(document).on("click", "a.taskman-colheader", function(event) {
		var col = $(this).attr("data-colname");
		if (taskmanager.getSortCol() == col) {
			taskmanager.setSortAscending(!taskmanager.isSortAscending());
		}
		taskmanager.setSortCol(col);
		loadTaskList();
		return false;
	});
	$(document).on("click", "#filterform a", function(event) {
		taskmanager.setFilter(filterControl.val());
		loadTaskList();
		return false;
	});
	$(document).on("submit", "#filterform", function(event) {
		taskmanager.setFilter(filterControl.val());
		loadTaskList();
		return false;
	});
	newTaskForm.on("reset", function() {
		newTaskForm.find(".ui-state-error-text").remove();
		newTaskForm.find("[name='num_priority']").val(1).removeClass("ui-state-error");
		newTaskForm.find("[name='txt_type']").val("A").removeClass("ui-state-error");
		newTaskForm_descripition.val("").removeClass("ui-state-error");
		return false;
	});

	// Backbonejs view render
	var tasklist_view = new TaskListView({ el : $("#table-holder"), collection: myTasks });
	var user_view = new UserView({ el : $("#account-info"), model: thisUser});
	var error_view = new ErrorListView({ el : $("#errormessages"), collection: errorMessages});

	$(function() {
		// JQuery UI init
		$("#btn-create-new-task").button();
		$("#filterform a").button();
		$("#accordion").accordion({
			heightStyle: "content",
			collapsible: true,
			active: false
		});
		var sessionInterval;

		function doLoginForm() {
			loginDialog.find(".ui-state-error-text").remove();
			loginDialog.find(".ui-state-error").removeClass("ui-state-error");
			function fieldError(field, err) {
				field.addClass("ui-state-error");
				var $erricon = $("<span></span>");
				$erricon.addClass("ui-icon").addClass("ui-icon-alert");
				var $err = $("<span></span>");
				$err.append($erricon);
				$err.append(err);
				$err.addClass("ui-state-error-text");
				field.parent().prev().before($err);
			}
			var hasError = false;
			if (loginFormFname.val().length == 0) {
				fieldError(loginFormFname, "Must have a name");
				hasError = true;
			}
			if (loginFormSname.val().length == 0) {
				fieldError(loginFormSname, "Must have a name");
				hasError = true;
			}
			if (hasError) {
				return false;
			}
			errorMessages.reset();
			$.ajax({
				type: "POST",
				async: false,
				dataType: "json",
				url : CONFIG.brokerUrl,
				data : {
					_program : "taskman.login.sas",
					_service : CONFIG.defaultService,
					fname : loginFormFname.val(),
					sname : loginFormSname.val()
				},
				success: function(data) {
					taskmanager.setServerInfo(data);
					thisUser.fetch({
						async: false,
						url : CONFIG.brokerUrl,
						data : $.extend({}, taskmanager.getServerInfo(), {
							_program : "taskman.userinfo.sas"
						}),
						error: function(model, jqXHR) {
						   var msg = jqXHR.getResponseHeader("message");
						   if (!msg) {
							   msg = "Unspecified error";
						   }
						   errorMessages.add([{ severity: "err", msg: msg }]);
					   },
					   success: function() {
						   user_view.render();
						   loadTaskList(function() {
							   $("#outer").show();
							   /**
								* Keep session alive
								*/
							   sessionInterval = setInterval(function () {
								   taskmanager.checkLogin(function() {}, function() {
									   newTaskDialog.dialog( "close" );
									   loginDialog.dialog( "open" );
									   $("#outer").hide();
									   errorMessages.reset();
									   errorMessages.add([{
										   severity: "err",
										   msg:"Session expired"
									   }]);
								   });
							   }, 30000);
							   errorMessages.reset();
							   loginDialog.dialog( "close" );
						   });
					   }
					});
				},
				error: function() {
					errorMessages.reset();
					errorMessages.add([{
						severity:"err",
						msg:"Was unable to login, check broker is running"
					}]);
				}
			});
		}

		loginDialog.on("submit", function(event) {
			doLoginForm();
			return false;
		});
		loginDialog.on("keydown", function(event) {
			if (event.which == 13) {
				doLoginForm();
				return false;
			}
		});

		loginDialog.dialog({
			autoOpen: true,
			modal: true,
			resizable: false,
			draggable: false,
			height: 240,
			width: 350,
			buttons: {
				"Login": function() {
					doLoginForm();
				},
				Cancel: function() {}
			},
			close: function() {},
			open: function() {
				if (sessionInterval) {
					clearInterval(sessionInterval);
				}
			},
			create: function() {
				// Remove X and Cancel buttons
				$(this).closest(".ui-dialog").find(".ui-icon-closethick").remove();
				$(this).closest(".ui-dialog").find(".ui-button").filter(function() {
					return $(this).text() == "Cancel";
				}).remove();
			}
		});


		// New Task Form Dialog
		newTaskDialog.find("[name='num_priority']").spinner({
			max: 5,
			min: 1
		});
		newTaskForm[0].reset();
		newTaskDialog.dialog({
			autoOpen: false,
			height: 330,
			width: 400,
			modal: true,
			resizable: false,
			draggable: false,
			open: function() {
				newTaskForm[0].reset();
			},
			buttons: {
				"Create": function() {
					function fieldError(field, err) {
						field.addClass("ui-state-error");
						var $erricon = $("<span></span>");
						$erricon.addClass("ui-icon").addClass("ui-icon-alert");
						var $err = $("<span></span>");
						$err.append($erricon);
						$err.append(err);
						$err.addClass("ui-state-error-text");
						field.parent().prepend($err);
					}
					if (newTaskForm_descripition.val().length == 0) {
						fieldError(newTaskForm_descripition, "Must have a description");
						return false;
					}
					var that = $(this);
					$.ajax({
						url : CONFIG.brokerUrl,
						type: "POST",
						data : $.extend({}, taskmanager.getServerInfo(), {
							_program : "taskman.createtask.sas",
							description: newTaskForm_descripition.val(),
							type: newTaskForm.find("[name='txt_type']").val(),
							priority: newTaskForm.find("[name='num_priority']").val()
						}),
						dataType : "json",
						complete: function(jqXHR) {
							if (jqXHR.status == 201) {
								loadTaskList(function() {
									that.dialog( "close" );
								});
							} else {
								errorMessages.add([{
									severity: "err",
									msg: "Error creating new task"
								}]);
							}
						}
					});
				},
				Cancel: function() {
					$(this).dialog("close");
				}
			},
			close: function() {
				newTaskForm[0].reset();
			}
		});

	});
});
