/***
 * A light weight datatable
 */

var Datatable = {

	/**
	 * Holds state about sorting etc..
	 */
	newDatatable : function() {
					   var privateState = {
						   sortCol : '',
						   sortAscending : true,
						   page : 1,
						   pageSize : 20,
						   numPages : 0
					   };
					   var thisObj = {};
					   thisObj.setSortCol = function(col) {
						   privateState.sortCol = col;
					   }
					   thisObj.getSortCol = function() {
						   return privateState.sortCol;
					   }
					   thisObj.setSortAscending = function(b) {
						   privateState.sortAscending = b;
					   }
					   thisObj.isSortAscending = function() {
						   return privateState.sortAscending;
					   }
					   thisObj.clearFilters = function() {
						   // TODO
					   }
					   thisObj.addFilter = function(column, value) {
						   // TODO
					   }
					   thisObj.setPage = function(number) {
						   privateState.page = number;
					   }
					   thisObj.getPage = function() {
						   return privateState.page;
					   }
					   thisObj.setPageSize = function(size) {
						   privateState.pageSize = size;
					   }
					   thisObj.getPageSize = function() {
						   return privateState.pageSize;
					   }
					   thisObj.setNumberOfPages = function(n) {
						   privateState.numPages = n;
					   }
					   thisObj.getNumberOfPages = function() {
						   return privateState.numPages;
					   }
					   thisObj.setNumberOfItems = function(i) {
						   privateState.numItems = i;
					   }
					   thisObj.getNumberOfItems = function() {
						   return privateState.numItems;
					   }
					   return thisObj;
				   },

	/**
	 * Wraps a collection to provide datatable functionality
	 *
	 * @serverInfo :
	 * @program : string of the name of the program to invoke on the WPS/Web server
	 * @url : URL of the broker
	 * @collection : backbone.js collection to add results to
	 * @errorMessages : backbone.js collection for error messages
	 * @view
	 * @additionalParams : function to be called to generate additional parameters for the request i.e. filters
	 */
	newBADatatable : function(serverInfo, program, url, collection, errorMessages, view, additionalParams) {
						   var base = Datatable.newDatatable();
						   return $.extend(base, {
							   load : function(callback) {
								    var additional = {};
									if (additionalParams) {
										additional = additionalParams();
									}
									var jqXHR = collection.fetch({
										async: false,
										url : url,
										data : $.extend({}, serverInfo, {
											_program : program,
											sortCol : base.getSortCol(),
											sortAsc : base.isSortAscending(),
										    page : base.getPage(),
										    pageSize : base.getPageSize()
										}, additional),
										error: function(model, jqXHR) {
											var msg = jqXHR.getResponseHeader("message");
											if (!msg) {
												msg = "Unspecified error";
											}
											errorMessages.add([{ severity: "err", msg: msg }]);
										},
										success : function(collection, response, options) {
											if (callback) {
												callback();
											}
										},
										traditional: true
									});
									var items = parseInt(jqXHR.getResponseHeader('X-wps-numberOfItems'), 10);
									base.setNumberOfItems(items);
								    base.setNumberOfPages(Math.max(1, Math.ceil(items/base.getPageSize())));
									// Check we're not beyond the last page
									if (base.getNumberOfPages() < base.getPage()) {
										base.setPage(base.getNumberOfPages());
										base.load();
										return;
									} else {
										view.render(base);
									}
								  }
						   });
					   }

};
