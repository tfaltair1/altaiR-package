define([ "require", "exports", "codemirror/lib/codemirror", "./wps-lang" ],

function(require, exports, CodeMirror) {
	"use strict";
	if (!String.prototype.format) {
		String.prototype.format = function() {
			var args = arguments;
			return this.replace(/{(\d+)}/g, function(match, number) {
				return typeof args[number] != 'undefined' ? args[number] : match;
			});
		};
	}

	// We call the mode "wps5.23".
	// It is not really a generic SAS language highlighting mode, it is
	// specific
	// to
	// language support in a particular version of WPS. That information
	// though
	// is
	// all held in the langinfo configuration file, so conceivably one
	// could
	// abstract that
	// file out into a separate require.js path and make this a generic
	// SAS
	// language
	// mode.
	var modeName = "wps5.23";
	var globalState = new com.wpc.wps.language.context.tokenisation.state.GlobalState();
	CodeMirror.defineMode(modeName, function(config, parserConfig) {
		var StreamAdapter = function(stream) {
			this.stream = stream;
			this.markPos = -1;
		}
		StreamAdapter.prototype = {
			mark : function() {
				this.markPos = this.stream.pos;
			},
			rewind : function() {
				if (this.markPos >= 0) {
					this.stream.pos = this.markPos;
				}
			},
			getOffset : function() {
				return this.stream.pos;
			},
			setOffset : function(offset) {
				this.stream.pos = offset;
			},
			available : function() {
				return this.stream.string.length - this.stream.pos;
			},
			eos : function() {
				return this.stream.eol();
			},
			next : function() {
				return this.stream.next();
			},
			peek : function() {
				return this.stream.peek();
			},
			peekBack : function(startOffset) {
				return this.stream.string.substring(startOffset, this.stream.pos);
			},
			advance : function(count) {
				var start = this.getOffset();
				this.stream.pos += count;
				return this.stream.string.substring(start, this.stream.pos);
			},
			skip : function(count) {
				this.stream.pos += count;
			},
			skipSpace : function() {
				var pos = this.stream.pos;
				this.stream.eatSpace();
				return this.stream.pos - pos;
			},
			backup : function(count) {
				this.stream.backUp(count);
			},
			match : function(match) {
				var start = this.getOffset();
				this.stream.match(match, true, false);
				return this.getOffset() - start;
			},
			matchCaseInsensitive : function(match) {
				var start = this.getOffset();
				this.stream.match(match, true, true);
				return this.getOffset() - start;
			},

			skipUntil : function(including) {
				// arguments is all the function arguments, the match strings are all the strings after 'including'
				// (variable args used in Java)
				if (this.eos() || arguments.length == 1)
					return 0;
				var start = this.stream.pos;

				for (var i = 1; i < arguments.length; i++) {
					var match = arguments[i];
					var matchpos = this.stream.string.indexOf(match, start);
					if(matchpos >= 0) {
						break;
					}
				}
				if (matchpos == -1) {
					this.stream.pos = this.stream.string.length;
				} else if (including) {
					this.stream.pos = matchpos + match.length;
				} else {
					this.stream.pos = matchpos;
				}
				return this.stream.pos - start;

			},
			isNextCharacter : function(c, ignoreCharacters) {
				var result = -1;
				var offset = this.getOffset();
				var exit = false;
				while (!exit) {
					var curr = this.stream.string.substring(offset, offset + 1);
					if (curr == c) {
						exit = true;
						result = offset;
					} else {
						// Character doesn't match, can
						// we ignore it?
						var ignore = false;
						if (ignoreCharacters != null) {
							for (var i = 0; i < ignoreCharacters.length; i++) {
								if (curr == ignoreCharacters[i]) {
									ignore = true;
									break;
								}
							}
						}
						if (!ignore) {
							exit = true;
						}
					}
					offset++;
				}
				return result;
			}
		};

		return {

			// State contains the current state (state[0]) and next state (state[1])
			startState : function() {
				return [ globalState, null ];
			},

			copyState : function(state) {
				return [ state[0], state[1] ];
			},

			token : function(stream, state) {
				var sa = new StreamAdapter(stream);
				var startPos = stream.pos;
				while (stream.pos == startPos) {
					// Transition to the next state before tokenising
					if (state[1] != null) {
						state[0] = state[1];
					}
					var result = state[0].tokenise(sa);
					if (result == null) {
						// no result
						if (stream.pos == startPos) {
							// no stream advance
							stream.next();
						}
						return "";
					} else if (state[0] == result.nextState && stream.pos == startPos) {
						// something wrong here as the
						// state hasn't changed
						break;
					} else if (result.nextState != null) {
						state[1] = result.nextState;
					} else if (stream.pos == startPos) {
						// no stream advance and no new
						// state: error
						stream.next();
					}
				}

				return com.wpc.wps.language.context.tokenisation.TokenType[result.tokenType];
			},
			fold : "procdatamacror"

		/*
		 * For now turn off indentation until we understand it more. indent:
		 * function(state, textAfter) { return state[0].indent(textAfter); }
		 */
		};
	});
	var StringComparator = (function() {
		function StringComparator(tc, obj) {
		}
		StringComparator.prototype.compare = function(s0, s1) {
			return s0.localeCompare(s1);
		}
		return StringComparator;
	}());

	var Collection = (function() {
		function Collection(tc, obj) {
			this.tc = tc;
			this.obj = obj;
		}
		Collection.prototype.equals = function(that) {
			return this.obj = that.obj;
		}
		return Collection;
	}());
	var Iterator = (function() {
		function Iterator(array) {
			this.array = array;
			this.i = 0;
		}
		Iterator.prototype.hasNext = function() {
			return this.i < this.array.length;
		};
		Iterator.prototype.next = function() {
			return this.array[this.i++];
		}
		return Iterator;
	}());
	var List = (function(_super) {
		__extends(List, _super);
		function List(tc, array) {
			_super.call(this, tc, array);
		}
		List.prototype.get = function(i) {
			return this.obj[i];
		};
		List.prototype.size = function() {
			return this.obj.length;
		};
		List.prototype.iterator = function() {
			return new Iterator(this.obj);
		}
		return List;
	}(Collection));
	var ListBuilder = (function() {
		function ListBuilder(tc) {
			this.tc = tc;
			this.array = [];
		}
		ListBuilder.prototype.get = function(i) {
			return this.array[i];
		};
		ListBuilder.prototype.size = function() {
			return this.array.length;
		};
		ListBuilder.prototype.remove = function(i) {
			this.array.splice(i,1);
		};
		ListBuilder.prototype.add = function(o) {
			this.array.push(o);
		};
		ListBuilder.prototype.addAll = function(list) {
			for (var i = 0; i < list.obj.length; i++) {
				this.array.push(list.obj[i]);
			}
		};
		ListBuilder.prototype.build = function() {
			return new List(this.tc, this.array);
		}
		ListBuilder.prototype.buildSorted = function(comparator) {
			return this.sort(comparator, false);
		}
		ListBuilder.prototype.removeDuplicates = function(comparator) {
			return this.sort(comparator, true);
		}
		ListBuilder.prototype.sort = function(comparator, removeDuplicates) {
			var sorted = [];
			for (var i = 0; i < this.array.length; i++) {
				var e = this.array[i];
				inner: for (var j = 0; j <= sorted.length; j++) {
					if (j == sorted.length) {
						sorted.push(e);
						break inner;
					} else if (comparator.compare(e, sorted[j]) <= 0) {
						if (!removeDuplicates || !e.equals(sorted[j])) {
							// insert
							sorted.splice(j, 0, e);
						}
						break inner;
					}
				}
			}
			return new List(this.tc, sorted);
		}
		return ListBuilder;
	}());
	var Set = (function(_super) {
		__extends(Set, _super);
		function Set(tc, obj) {
			_super.call(this, tc, obj);
		}
		Set.prototype.size = function() {
			return this.obj.length;
		};
		Set.prototype.contains = function(str) {
			return this.obj[str];
		};
		Set.prototype.iterator = function() {
			return new Iterator(Object.keys(this.obj));
		}
		return Set;
	}(Collection));
	var SetBuilder = (function() {
		function SetBuilder(tc) {
			this.tc = tc;
			this.obj = {};
		}
		SetBuilder.prototype.add = function(str) {
			this.obj[str] = true;
		};
		SetBuilder.prototype.addAll = function(strs) {
			for (var i = 0; i < strs.length; i++) {
				this.obj[strs[i]] = true;
			}
		};
		SetBuilder.prototype.build = function() {
			return new Set(this.tc, this.obj);
		}
		return SetBuilder;
	}());
	var MapEntry = (function() {
		function MapEntry(key, value) {
			this.key = key;
			this.value = value;
		}
		MapEntry.prototype.getKey = function() {
			return this.key;
		}
		MapEntry.prototype.getValue = function() {
			return this.value;
		}
		return MapEntry;
	}());
	var Map = (function(_super) {
		__extends(Map, _super);
		function Map(tc, obj) {
			_super.call(this, tc, obj);
		}
		Map.prototype.containsKey = function(i) {
			return this.obj[i] != null;
		};
		Map.prototype.get = function(i) {
			return this.obj[i];
		};
		Map.prototype.entryCollection = function() {
			var builder = new ListBuilder(this.tc);
			for ( var key in this.obj) {
				builder.add(new MapEntry(key, this.obj[key]));
			}
			return builder.build();
		};
		Map.prototype.keySet = function() {
			var builder = new SetBuilder(this.tc);
			for ( var key in this.obj) {
				builder.add(key);
			}
			return builder.build();
		};
		Map.prototype.values = function() {
			var builder = new ListBuilder(this.tc);
			for ( var key in this.obj) {
				builder.add(this.obj[key]);
			}
			return builder.build();
		};
		Map.prototype.size = function() {
			return this.obj.length;
		};

		return Map;
	}(Collection));
	var MapBuilder = (function() {
		function MapBuilder(tc) {
			this.tc = tc;
			this.obj = {};
		}
		MapBuilder.prototype.put = function(k, v) {
			this.obj[k] = v;
		};
		MapBuilder.prototype.putAll = function(map) {
			for (var key in map.obj) {
				this.put(key, map.get(key));
			}
		};
		MapBuilder.prototype.build = function(map) {
			return new Map(this.tc, this.obj);
		};
		return MapBuilder;
	}());
	var Collections = (function(_super) {
		__extends(Collections, _super);
		function Collections() {
			_super.call(this);
		}
		Collections.prototype.transpilableList = function(array) {
			return new List(this, array);
		};
		Collections.prototype.transpilableSet = function(strs) {
			var obj = {};
			for (var i = 0; i < strs.length; i++) {
				obj[strs[i]] = true;
			}
			return new Set(this, obj);
		};
		Collections.prototype.transpilableMapBuilder = function() {
			return new MapBuilder(this);
		};
		Collections.prototype.transpilableSetBuilder = function() {
			return new SetBuilder(this);
		};
		Collections.prototype.transpilableListBuilder = function() {
			return new ListBuilder(this);
		};
		return Collections;
	}(com.wpc.wps.language.context.utils.TranspilableCollections));
	var tc = new Collections();

	var slsl = new com.wpc.wps.language.context.support.SasLanguageSupport_Lua();
	var slsm = new com.wpc.wps.language.context.support.SasLanguageSupport_Macro();
	var sls = new com.wpc.wps.language.context.support.SasLanguageSupport();
	slsl.transpilableCollections = tc;
	slsl.postConstruct();
	slsm.transpilableCollections = tc;
	slsm.postConstruct();
	sls.transpilableCollections = tc;
	sls.lua = slsl;
	sls.macro = slsm;
	sls.postConstruct();
	var bsth = new com.wpc.wps.language.context.tokenisation.state.BasicStateTransitionHelper();
	bsth.sasLanguageSupporter = sls;
	
	var fh = new com.wpc.wps.language.context.tokenisation.state.BasicFunctionHelper();
	fh.sasLanguageSupporter = sls;

	var sasContentAssist = new com.wpc.wps.language.context.common.SasContentAssist();
	sasContentAssist.sasLanguageSupporter = sls;
	sasContentAssist.transpilableCollections = tc;

	var docap = new com.wpc.wps.language.context.proposer.DatastepOptionsContentAssistProposer();
	docap.transpilableCollections = tc;
	sasContentAssist.datastepOptionsContentAssistProposer = docap;

	var fmtcap = new com.wpc.wps.language.context.proposer.FormatContentAssistProposer();
	fmtcap.sasLanguageSupporter = sls;
	fmtcap.transpilableCollections = tc;
	fmtcap.postConstruct();
	sasContentAssist.formatContentAssistProposer = fmtcap;

	var fcap = new com.wpc.wps.language.context.proposer.FunctionContentAssistProposer();
	fcap.sasLanguageSupporter = sls;
	fcap.transpilableCollections = tc;
	fcap.postConstruct();
	sasContentAssist.functionContentAssistProposer = fcap;

	var ifcap = new com.wpc.wps.language.context.proposer.ImlFunctionContentAssistProposer();
	ifcap.sasLanguageSupporter = sls;
	ifcap.transpilableCollections = tc;
	ifcap.postConstruct();
	sasContentAssist.imlFunctionContentAssistProposer = fcap;

	var lncap = new com.wpc.wps.language.context.proposer.LibnameContentAssistProposer();
	lncap.sasLanguageSupporter = sls;
	lncap.transpilableCollections = tc;
	lncap.postConstruct();
	sasContentAssist.libnameContentAssistProposer = lncap;

	var lovcap = new com.wpc.wps.language.context.proposer.LibnameOptionValueContentAssistProposer();
	lovcap.sasLanguageSupporter = sls;
	lovcap.transpilableCollections = tc;
	sasContentAssist.libnameOptionValueContentAssistProposer = lovcap;

	var gscap = new com.wpc.wps.language.context.proposer.GlobalStateContentAssistProposer();
	gscap.sasLanguageSupporter = sls;
	gscap.transpilableCollections = tc;
	gscap.postConstruct();
	sasContentAssist.globalStateContentAssistProposer = gscap;

	var ovcap = new com.wpc.wps.language.context.proposer.OptionValueContentAssistProposer();
	ovcap.transpilableCollections = tc;
	sasContentAssist.optionValueContentAssistProposer = ovcap;

	var oscap = new com.wpc.wps.language.context.proposer.OptionsStatementContentAssistProposer();
	oscap.transpilableCollections = tc;
	sasContentAssist.optionsStatementContentAssistProposer = oscap;

	var pccap = new com.wpc.wps.language.context.proposer.ProcChooserContentAssistProposer();
	pccap.sasLanguageSupporter = sls;
	pccap.transpilableCollections = tc;
	pccap.postConstruct();
	sasContentAssist.procChooserContentAssistProposer = pccap;

	var pocap = new com.wpc.wps.language.context.proposer.ProcOptionsContentAssistProposer();
	pocap.transpilableCollections = tc;
	sasContentAssist.procOptionsContentAssistProposer = pocap;

	var scap = new com.wpc.wps.language.context.proposer.StatementContentAssistProposer();
	scap.transpilableCollections = tc;
	scap.sasLanguageSupporter = sls;
	sasContentAssist.statementContentAssistProposer = scap;

	var sscap = new com.wpc.wps.language.context.proposer.StepStateContentAssistProposer();
	sscap.transpilableCollections = tc;
	sasContentAssist.stepStateContentAssistProposer = sscap;

	var crcap = new com.wpc.wps.language.context.proposer.CallRoutineContentAssistProposer();
	crcap.transpilableCollections = tc;
	crcap.sasLanguageSupporter = sls;
	crcap.postConstruct();
	sasContentAssist.callRoutineContentAssistProposer = crcap;

	var mcap = new com.wpc.wps.language.context.proposer.MacroContentAssistProposer();
	mcap.transpilableCollections = tc;
	mcap.sasLanguageSupporter = sls;
	mcap.postConstruct();
	sasContentAssist.macroContentAssistProposer = mcap;

	var cccap = new com.wpc.wps.language.context.proposer.ComponentChooserContentAssistProposer();
	cccap.transpilableCollections = tc;
	cccap.sasLanguageSupporter = sls;
	cccap.postConstruct();
	sasContentAssist.componentChooserContentAssistProposer = cccap;
	
	var sqlcap = new com.wpc.wps.language.context.proposer.SqlContentAssistProposer();
	sqlcap.transpilableCollections = tc;
	sasContentAssist.sqlContentAssistProposer = sqlcap;

	var strComp = new StringComparator();

	var ptComp = new com.wpc.wps.language.context.comparator.DisplayProposalTypePriorityComparator();

	var dpc = new com.wpc.wps.language.context.comparator.DisplayProposalComparator();
	dpc.stringComparator = strComp;
	dpc.proposalTypeComparator = ptComp;
	sasContentAssist.displayProposalComparator = dpc;

	var tpc = new com.wpc.wps.language.context.comparator.TextProposalComparator();
	tpc.stringComparator = strComp;
	sasContentAssist.textProposalComparator = tpc;

	sasContentAssist.postConstruct();
	globalState.sasLanguageSupporter = sls;
	globalState.stateTransitionHelper = bsth;
	globalState.functionHelper = fh;
	globalState.transpilableCollections = tc;

	var pipd = new com.wpc.wps.language.context.proposer.ProposalImagePathDirectory();

	exports.contentassist = function(cm, option) {
		return new Promise(function(accept) {
			setTimeout(function() {
				var cursor = cm.getCursor();
				var tokens = cm.getLineTokens(cursor.line);
				if (tokens.length == 0) {
					var token = cm.getTokenAt(cursor);
				}
				// find the token immediately BEFORE the
				// current position to get the right
				// state
				// BUT you need the token ON the cursor
				// to get the right token type...
				for (var i = tokens.length - 1; i >= 0; i--) {
					var typeToken = token;
					var token = tokens[i];
					if (token.end < cursor.ch) {
						break;
					}
				}
				// carry on stepping back through tokens to
				// get the name token
				var tokenName = "";
				var prevToken = typeToken;
				for (; i >= 0; i--) {
					var nameToken = tokens[i];
					if (prevToken != null && prevToken.string == '=') {
						tokenName = nameToken.string;
						break;
					}
					var prevToken = nameToken;
				}
				/*
				 * bit of a fiddle here, if you're on the first token, you can't
				 * get the state at the beginning of the line, but then if you
				 * start typing you get UnknownStatementState.
				 */
				var state = token.state[0];
				if (token === tokens[0]) {
					if (token.state[0] instanceof com.wpc.wps.language.context.tokenisation.state.UnknownStatementState) {
						var state = state.getParent();
					} else if (token.state[0] instanceof com.wpc.wps.language.context.tokenisation.state.IdentifierState) {
						var state = state.stateIfNotAssignment;
					}
				}
				var line = cm.getLine(cursor.line);
				var start = cursor.ch;
				var end = cursor.ch;
				while (start && (/\w/.test(line.charAt(start - 1)) || line.charAt(start - 1) == '%'))
					--start;
				var fragment = line.slice(start, end);
				var tokenType = typeToken != null ? com.wpc.wps.language.context.tokenisation.TokenType[typeToken.type] : null;
				var proposals = sasContentAssist.getProposals(new com.wpc.wps.language.context.common.ContentAssistContext(state, tokenType, tokenName, fragment));
				var proposalObjs = [];
				for (var i = 0; i < proposals.size(); i++) {
					var proposal = proposals.get(i);
					proposalObjs.push({
						text : proposal.getText(),
						type : proposal.getType(),
						render : function(elt, data, cur) {
							var child = document.createTextNode(" " + cur.text);
							var imgPath = pipd.getImagePath(cur.type);
							var img = document.createElement("img");
							img.setAttribute("src", imgPath);
							elt.appendChild(img);
							elt.appendChild(child);
						}
					});
				}
				return accept({
					list : proposalObjs,
					from : CodeMirror.Pos(cursor.line, start),
					to : CodeMirror.Pos(cursor.line, end)
				});
			}, 100)
		})
	};
	var ErrorHandler = (function() {
		function ErrorHandler() {
			this.errors = [];
			this.messages = {
				proc_0_NotKnown:'Procedure {0} not known',
				invalidMacroName:'Invalid Macro name',
				invalidDataName:'Invalid Dataset name',
				invalidOption:'Invalid option',
				expectedNullMissingButFound_0_:'ERROR: expected NULL or MISSING but found "{0}"',
				statement_0_UnknownInThisContext:'The statement "{0}" is unknown in this context',
				expectedThenOrSemicolonButFound_0_:'ERROR: expected THEN or ; but found "{0}"',
				expectedPercentThenOrSemicolonButFound_0_:'ERROR: expected %THEN or ; but found "{0}"',
				expectedSemicolonButFound_0_:'ERROR: expected ; but found "{0}"',
				expectedEqualsButFound_0_:'ERROR: expected :\' but found "{0}"',
				expectedCloseBracketButFound_0_:'ERROR: expected ) but found "{0}"',
				expectedOpenBracketButFound_0_:'ERROR: expected ( but found "{0}"',
				expectedNameButFound_0_:'ERROR: expected a name but found "{0}"',
				expectedANameNumericOrStringConstantButFound_0_:'ERROR: Expected a name, numeric or string constant, but found "{0}"',
				expectedToByWhileUntilButFound_0_:'ERROR: expected TO, BY, WHILE, UNTIL or ; but found "{0}"',
				expectedByWhileUntilButFound_0_:'ERROR: expected BY, WHILE, UNTIL or ; but found "{0}"',
				expectedToWhileUntilButFound_0_:'ERROR: expected TO, WHILE, UNTIL or ; but found "{0}"',
				expectedWhileUntilButFound_0_:'ERROR: expected WHILE, UNTIL or ; but found "{0}"',
				expectedALiteral:'ERROR: Expected a literal',
				expectedNullMissingButFound_0_:'ERROR: expected NULL or MISSING but found "{0}"',
				valuesOnRightOfInExpressionMustAllBeNumericOrCharacter:'ERROR: The values on the right hand side of an IN expression must all be numeric, or all be character',
				unknownStatement:'Unknown statement',
				procOption_0_notKnownOn_1_:'PROC option "{0}" not known in PROC {1}',
				datastepFunction_0_notKnown:'DATASTEP function "{0}" not known',
				globalStatement_0_notKnown:'Global statement "{0}" not known',
				procStatement_0_notKnownOn_1_:'"PROC statement {0}" not known in PROC {1}',
				dataStatement_0_notKnown_:'"DATA statement {0}" not known',
				format_0_notKnown:'Format "{0}" not known',
				informat_0_notKnown:'Informat "{0}" not known',
				systemOption_0_notKnown:'System option "{0}" not known',
				datastepOption_0_notKnown:'Datastep option "{0}" not known',
				callRoutine_0_notKnown:'CALL routine "{0}" not known',
				odsDestination_0_notKnown:'ODS destination "{0}" not known'
			};
		}
		ErrorHandler.prototype.pushErr = function(token, key, severity, originalArguments) {
			var args = [ originalArguments.length - 2 ];
			for (var i = 2; i < originalArguments.length; i++) {
				args[i - 2] = originalArguments[i];
			}
			// TODO I18N
			var err = {
				message : this.messages[key] == null ? 'ERROR' : this.messages[key].format(args),
				severity : severity,
				from : CodeMirror.Pos(token.line, token.wrapped.start),
				to : CodeMirror.Pos(token.line, token.wrapped.end)
			};
			this.errors.push(err);
		}
		ErrorHandler.prototype.error = function(token, key) {
			this.pushErr(token, key, "error", arguments);
		};
		ErrorHandler.prototype.warn = function(token, key) {
			this.pushErr(token, key, "warn", arguments);
		};
		ErrorHandler.prototype.info = function(token, key) {
			this.pushErr(token, key, "info", arguments);
		};
		return ErrorHandler;
	}());
	// static reference to the codeFolder in use so that we can track
	// which folding is current
	var activeCodeFolder = null;
	var CodeFolder = (function() {
		function CodeFolder(type) {
			this.type = type;
			this.macroCount = 0;
		}
		CodeFolder.prototype.started = function(token) {
			if (activeCodeFolder == null) {
				this.start = CodeMirror.Pos(token.line, token.wrapped.end);
				activeCodeFolder = this;
			}
		};

		CodeFolder.prototype.finished = function(token) {
			if (this.start != null && activeCodeFolder == this) {
				this.finish = CodeMirror.Pos(token.line, token.wrapped.end);
			}
		};
		CodeFolder.prototype.setName = function() {
			// don't care about the name
		};
		return CodeFolder;
	}());
	var MacroCodeFolder = (function() {
		function MacroCodeFolder() {
			this.macroCount = 0;
		}
		MacroCodeFolder.prototype.started = function(token) {
			if (activeCodeFolder == null || activeCodeFolder == this) {
				if (this.macroCount == 0) {
					this.start = CodeMirror.Pos(token.line, token.wrapped.end);
				}
				this.macroCount++;
				activeCodeFolder = this;
			}
		};
		MacroCodeFolder.prototype.finished = function(token) {
			if (activeCodeFolder == this) {
				this.macroCount--;
				if (this.start != null && this.macroCount == 0) {
					this.finish = CodeMirror.Pos(token.line, token.wrapped.end);
				}
			}
		};
		MacroCodeFolder.prototype.setName = function() {
			// don't care about the name
		};
		return MacroCodeFolder;
	}());
	var StringLookup = (function() {
		function StringLookup(cm) {
			this.cm = cm;
		}
		StringLookup.prototype.getString = function(token) {
			if (token.wrapped == null) {
				return "";
			}
			// hack to get end of line token string
			if (token.wrapped.eol) {
				return "\n";
			}
			return this.cm.getLine(token.line).substring(token.wrapped.start, token.wrapped.end);
		};
		StringLookup.prototype.getLine = function(token) {
			return token.line;
		};
		return StringLookup;
	}());
	var Token = (function() {
		function Token(line, cmToken, state) {
			this.line = line;
			this.wrapped = cmToken;
			this.state = state;
			if (this.wrapped != null) {
				// var tokenTypeStr =
				// this.wrapped.type.substr(this.wrapped.type.indexOf("
				// ") + 1);
				this.tokenType = com.wpc.wps.language.context.tokenisation.TokenType[this.wrapped.type];
			}
		}
		Token.prototype.getTokenType = function() {
			return this.tokenType;
		};
		Token.prototype.getState = function() {
			return this.state;
		};
		Token.prototype.getOffset = function() {
			// not actually the offset from the whole document, but enough to work with ModelBuilder...
			return this.wrapped.start;
		};
		Token.prototype.getLength = function() {
			return this.wrapped.end - this.wrapped.start;
		};
		return Token;
	}());
	var lintHelper = function(text, options, cm) {
		var eh = new ErrorHandler();
		var parser = new com.wpc.wps.language.context.model.SasParser();
		parser.transpilableCollections = tc;
		parser.functionHelper = fh;
		parser.expressionParser = new com.wpc.wps.language.context.model.SimpleExpressionParser();
		var pds = new com.wpc.wps.language.context.model.ParserDelegateStore();
		pds.transpilableCollections = tc;
		pds.postConstruct();
		parser.parserDelegateStore = pds;
		parser.connectParser(new StringLookup(cm), null, new com.wpc.wps.language.context.model.EditorParseErrorListener(eh));
		var tokens = [];
		for (var i = 0; i < cm.lineCount(); i++) {
			var lineTokens = cm.getLineTokens(i);
			for (var j = 0; j < lineTokens.length; j++) {
				var lineToken = lineTokens[j];
				var state = lineToken.state[0];
				tokens.push(new Token(i, lineToken, state));
			}
		}
		parser.processTokenArray(tokens);
		return eh.errors;
	};
	function hasPreviousComment(start, cm) {
		var prevLine = start.line - 1;
		if (prevLine >= 0) {
			var prevLineTokens = cm.getLineTokens(prevLine);
			for (var l = prevLineTokens.length - 1; l >= 0; l--) {
				var tokenType = new Token(prevLine, prevLineTokens[l]).getTokenType();
				if (tokenType != null) {
					if (tokenType == com.wpc.wps.language.context.tokenisation.TokenType.comment) {
						return true;
					} else {
						return false;
					}
				}
			}
		}
		return false;
	}
	var CodemirrorModelBuilder = (function(_super) {
		__extends(CodemirrorModelBuilder, _super);
		function CodemirrorModelBuilder() {
			_super.call(this);
		}
		CodemirrorModelBuilder.prototype.isAssignableToBranchNode = function() {
			return false;
		}
		return CodemirrorModelBuilder;
	}(com.wpc.wps.language.context.model.ModelBuilder));
	var codeFolder = function(cm, start) {
		var sl = new StringLookup(cm);
		var mb = new CodemirrorModelBuilder();
		mb.cardsCallback = new CodeFolder("cards");
		mb.commentCallback = new CodeFolder("comment");
		mb.datastepCallback = new CodeFolder("data");
		mb.macroDefinitionCallback = new MacroCodeFolder();
		mb.procCallback = new CodeFolder("proc");
		mb.rCallback = new CodeFolder("r");
		mb.transpilableCollections = tc;
		mb.postConstruct();

		mb.connect(sl);
		// special end of line token as CodeMirror does not generate
		// them, needed for multiline comments
		var eolToken = {
			eol : true,
			type : ""
		};
		// state at the end of previous line or global state if it's the
		// first line
		var state = start.line > 0 ? cm.getStateAfter(start.line - 1)[0] : new com.wpc.wps.language.context.tokenisation.state.GlobalState();
		var prevToken = start.line > 0 ? new Token(start.line - 1, eolToken, state) : null;

		activeCodeFolder = null;
		mb.currentCodeFolder = null;
		for (var i = start.line; i < cm.lineCount(); i++) {
			var tokens = cm.getLineTokens(i);
			for (var j = 0; j <= tokens.length; j++) {
				var token = new Token(i, j == tokens.length ? eolToken : tokens[j], state);
				var nextState = j == tokens.length ? state : tokens[j].state[0];
				prevToken = mb.processTokensIncremental(token, prevToken, nextState);
				state = nextState;
				// special case for multiline comments
				if (i == start.line && activeCodeFolder != null && activeCodeFolder.type == "comment" && hasPreviousComment(start, cm)) {
					return null;
				} else if (activeCodeFolder != null && activeCodeFolder.finish != null) {
					return {
						from : activeCodeFolder.start,
						to : activeCodeFolder.finish
					};
				}
			}

			if (i == start.line && activeCodeFolder == null) {
				// got to the end of the first line, but no folding type
				// found
				return null;
			}
		}
		return null;
	};
	CodeMirror.registerHelper("lint", "wps5.23", lintHelper);
	CodeMirror.registerHelper("fold", "procdatamacror", codeFolder);
});
