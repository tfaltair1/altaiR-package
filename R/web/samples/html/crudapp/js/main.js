TemplateManager.cache([
		"item",
		"item_list",
		"userinfo",
		"error"]).done(function() {
	var errorMessages = new ErrorMessageList();

	/// Get tasks list
	var itemsList = new DatatableList();

	var catList = new CatList();

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

	var TransferSelectView = Backbone.View.extend({
		initialize: function(options) {
			this.collection.bind("reset", this.render, this);
			this.collection.bind("add", this.render, this);
			this.collection.bind("remove", this.render, this);
		},
		render: function() {
			var variables = {
				items : this.collection.models,
		        name : this.$el.attr('data-name')
			};
			this.$el.html('');
			var template = _.template(TemplateManager.get("items-transfer-select"), variables);
			this.$el.append(template);
			this.$el.find('select').multiselect2side({
				selectedPosition: 'right',
				moveOptions: false,
				labelsx: '',
				labeldx: '',
				autoSort: true,
				autoSortAvailable: true,
				minSize: 10
			});
		}
	});

	var DatatableRowView = Backbone.View.extend({
		initialize: function(options) {
			this.render(options.template);
		},
		render: function(template) {
			var variables = {
				id : this.model.id
			};
			$.extend(variables, this.model.toJSON());
			var template = _.template(TemplateManager.get(template), variables);
			this.$el.find("tbody").append(template);
		}
	});

	var DatatableView = Backbone.View.extend({
		initialize : function(options) {
		    this.__template = options.template;
			this.__rowTemplate = options.rowTemplate;
		},
		render: function(datatable) {
			var template = _.template(TemplateManager.get(this.__template), {
				numberOfPages : datatable.getNumberOfPages(),
			    numberOfItems : datatable.getNumberOfItems(),
			    showingMin : (datatable.getPage() == 1) ? 1 : (datatable.getPage()-1)*datatable.getPageSize(),
			    showingMax : (datatable.getPage() == datatable.getNumberOfPages()) ? datatable.getNumberOfItems() :
				    datatable.getPage() * datatable.getPageSize()
			});
			this.$el.html(template);
			var table = this.$el.find("table");
			if (this.collection.length > 0) {
				_.each(this.collection.models, function (task) {
					this.renderTask(task, table, this.__rowTemplate);
				}, this);
				var ic = $("<span></span>");
				ic.addClass("ui-icon");
				if (datatable.isSortAscending()) {
					ic.addClass("ui-icon-triangle-1-n");
				} else {
					ic.addClass("ui-icon-triangle-1-s");
				}
				var th = this.$el.find("a[data-colname='" + datatable.getSortCol() + "']").parent();
				th.prepend(ic);
				th.addClass("jtable-sorted-header");
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

			// Events
			var dt = datatable;
			this.$el.find("table").on("click", "th", function(event) {
				var anc = $(this).find("a");
				if (anc.size() > 0) {
					var col = anc.attr("data-colname");
					if (dt.getSortCol() == col) {
						dt.setSortAscending(!dt.isSortAscending());
					}
					dt.setSortCol(col);
					dt.load();
				}
				return false;
			});

			this.$el.find("select[name='pageSize']").val(dt.getPageSize());
			this.$el.find("select[name='pageSize']").change(function(event) {
				dt.setPageSize($(this).val());
				dt.load();
			});

			this.$el.find("select[name='pageNumber']").val(dt.getPage());
			this.$el.find("select[name='pageNumber']").change(function(event) {
				dt.setPage($(this).val());
				dt.load();
			});
		},
		renderTask : function(task, table, template) {
		  var tv = new DatatableRowView({el : table, model: task, template: template});
		}
	});

	// Backbonejs view render
	var error_view = new ErrorListView({ el : $("#errormessages"), collection: errorMessages});

	/// Time remaining
	var items_view = new DatatableView({
		el : $("#items-table"),
		collection: itemsList,
		template : "item_list",
		rowTemplate : "item"
	});
	var itemsDt = Datatable.newBADatatable({ _service : CONFIG.defaultService }, "crud.items.sas",
		CONFIG.brokerUrl, itemsList, errorMessages, items_view, function() {
			// TODO use cached JQuery identifier
			var form = $("#items-filter");
			var categories = [];
			form.find("[name='items']").find("[selected='selected']").each(function() {
				categories.push($(this).val());
			});
			var ret = {
		        categories : categories
			};
			return ret;
		});
	itemsDt.setSortCol("name");
	itemsDt.setSortAscending(true);

	var bugsDeveloperGraphView = new GraphView({
		el : $("#graph-img"),
		baseUrl : CONFIG.brokerUrl + "?_service=default&_program=crud.graph.sas",
		additionParameters : function() {
			var form = $("#items-filter");
			var categories = [];
			form.find("[name='items']").find("[selected='selected']").each(function() {
				categories.push($(this).val());
			});
			return {
				width : Math.round($("#graph-img").parent().width()) - 20,
				height : Math.round($("#graph-img").parent().height()) - 20,
		        categories : categories
			};
		}
	});

	$(function() {
		function getDevelopers() {
			catList.fetch({
				url : CONFIG.brokerUrl,
				data : {
					_service : CONFIG.defaultService,
					_program : 'crud.categories.sas'
				},
				error: function(model, jqXHR) {
						   var msg = jqXHR.getResponseHeader("message");
						   if (!msg) {
							   msg = "Unspecified error";
						   }
						   errorMessages.add([{ severity: "err", msg: msg }]);
					   }
			});
		}
		getDevelopers();

		$(".items-transfer-select").each(function() {
			var dts1 = new TransferSelectView({
				el : $(this),
				collection : catList
			});
		});

		$(document).on("change", "#items-filter select", function() {
			itemsDt.load();
			bugsDeveloperGraphView.render();
		});
		var $preparingFileModal = $("#preparing-file-modal").dialog({
			modal : true,
			autoOpen : false,
			resizable : false,
			draggable : false
		});
		$(document).on("click", "#items-download", function () {
			// TODO use cached JQuery identifier
			var form = $("#items-filter");
			var categories = [];
			form.find("[name='items']").find("[selected='selected']").each(function() {
				categories.push($(this).val());
			});
			var params = {
		        categories : categories,
			    _program : "crud.items_csv.sas",
			    _service : CONFIG.defaultService,
			    sortCol : itemsDt.getSortCol(),
			    sortAsc : itemsDt.isSortAscending()
			};
			var url = CONFIG.brokerUrl + "?" + $.param(params, true);
			$preparingFileModal.dialog("open");
			$.fileDownload(url, {
				successCallback: function (url) {
									 $preparingFileModal.dialog('close');
								 },
				failCallback: function (responseHtml, url) {
								  $preparingFileModal.dialog('close');
								  alert("Error downloading file");
							  }
			});
			return false;
		});

		$(window).resize(function() {
			bugsDeveloperGraphView.render();
		});

		var insertItemDialog = $("#insert-item");
		insertItemDialog.dialog({
			autoOpen: false,
			height: "auto",
			width: "auto",
			modal: true,
			resizable: false,
			buttons: {
				"Insert": function() {
					// TODO ajax
					var form = insertItemDialog.find("form");
					$.ajax({
						method: "POST",
					    url : CONFIG.brokerUrl,
					    data : {
							_program : "crud.insert_item.sas",
						    _service : CONFIG.defaultService,
							name : form.find("[name='name']").val(),
							category : form.find("[name='category']").val(),
							price : form.find("[name='price']").val(),
							sales : form.find("[name='sales']").val()
						},
						success : function() {
						    insertItemDialog.dialog( "close" );
							itemsDt.load();
							getDevelopers();
							itemsDt.load();
							bugsDeveloperGraphView.render();

						}
					});
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			}
		});

		var filterDialog = $("#filter-dialog");
		filterDialog.dialog({
			autoOpen: false,
			height: "auto",
			width: "auto",
			modal: true,
			resizable: false,
			draggable : true,
			buttons: {
				"Filter": function() {
					itemsDt.load();
					bugsDeveloperGraphView.render();
					filterDialog.dialog("close");
				},
				"Clear": function() {
					var form = filterDialog.find("form");
					form[0].reset();
					getDevelopers();
					itemsDt.load();
					bugsDeveloperGraphView.render();
					getDevelopers();
					$( this ).dialog( "close" );
				}
			}
		});

		$("#btn-insert-item").button();
		$(document).on("click", "#btn-insert-item", function() {
			insertItemDialog.dialog("open");
			return false;
		});
		$(document).on("submit", "#insert-item form", function() {
			return false;
		});

		$("#btn-filter").button();
		$(document).on("click", "#btn-filter", function() {
			filterDialog.dialog("open");
			return false;
		});
		$(document).on("submit", "#filter-dialog form", function() {
			return false;
		});

		getDevelopers();
		itemsDt.load();
		bugsDeveloperGraphView.render();
	});
});
