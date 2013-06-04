// Backbone.CollectionBinder v1.0.2
// (c) 2013 Bart Wood
// Distributed Under MIT License

(function(){if(!Backbone){throw"Please include Backbone.js before Backbone.ModelBinder.js"}if(!Backbone.ModelBinder){throw"Please include Backbone.ModelBinder.js before Backbone.CollectionBinder.js"}Backbone.CollectionBinder=function(e,t){_.bindAll.apply(_,[this].concat(_.functions(this)));this._elManagers={};this._elManagerFactory=e;if(!this._elManagerFactory)throw"elManagerFactory must be defined.";this._elManagerFactory.trigger=this.trigger;this._options=t||{}};Backbone.CollectionBinder.VERSION="1.0.1";_.extend(Backbone.CollectionBinder.prototype,Backbone.Events,{bind:function(e,t){this.unbind();if(!e)throw"collection must be defined";if(!t)throw"parentEl must be defined";this._collection=e;this._elManagerFactory.setParentEl(t);this._onCollectionReset();this._collection.on("add",this._onCollectionAdd,this);this._collection.on("remove",this._onCollectionRemove,this);this._collection.on("reset",this._onCollectionReset,this);this._collection.on("sort",this._onCollectionSort,this)},unbind:function(){if(this._collection!==undefined){this._collection.off("add",this._onCollectionAdd);this._collection.off("remove",this._onCollectionRemove);this._collection.off("reset",this._onCollectionReset);this._collection.off("sort",this._onCollectionSort)}this._removeAllElManagers()},getManagerForEl:function(e){var t,n,r=_.values(this._elManagers);for(t=0;t<r.length;t++){n=r[t];if(n.isElContained(e)){return n}}return undefined},getManagerForModel:function(e){return this._elManagers[_.isObject(e)?e.cid:e]},_onCollectionAdd:function(e){this._elManagers[e.cid]=this._elManagerFactory.makeElManager(e);this._elManagers[e.cid].createEl();if(this._options["autoSort"]){this.sortRootEls()}},_onCollectionRemove:function(e){this._removeElManager(e)},_onCollectionReset:function(){this._removeAllElManagers();this._collection.each(function(e){this._onCollectionAdd(e)},this);this.trigger("elsReset",this._collection)},_onCollectionSort:function(){if(this._options["autoSort"]){this.sortRootEls()}},_removeAllElManagers:function(){_.each(this._elManagers,function(e){e.removeEl();delete this._elManagers[e._model.cid]},this);delete this._elManagers;this._elManagers={}},_removeElManager:function(e){if(this._elManagers[e.cid]!==undefined){this._elManagers[e.cid].removeEl();delete this._elManagers[e.cid]}},sortRootEls:function(){this._collection.each(function(e,t){var n=this.getManagerForModel(e);if(n){var r=n.getEl();var i=$(this._elManagerFactory.getParentEl()).children();if(i[t]!==r[0]){r.detach();r.insertBefore(i[t])}}},this)}});Backbone.CollectionBinder.ElManagerFactory=function(e,t){_.bindAll.apply(_,[this].concat(_.functions(this)));this._elHtml=e;this._bindings=t;if(!_.isString(this._elHtml))throw"elHtml must be a valid html string"};_.extend(Backbone.CollectionBinder.ElManagerFactory.prototype,{setParentEl:function(e){this._parentEl=e},getParentEl:function(){return this._parentEl},makeElManager:function(e){var t={_model:e,createEl:function(){this._el=$(this._elHtml);$(this._parentEl).append(this._el);if(this._bindings){if(_.isString(this._bindings)){this._modelBinder=new Backbone.ModelBinder;this._modelBinder.bind(this._model,this._el,Backbone.ModelBinder.createDefaultBindings(this._el,this._bindings))}else if(_.isObject(this._bindings)){this._modelBinder=new Backbone.ModelBinder;this._modelBinder.bind(this._model,this._el,this._bindings)}else{throw"Unsupported bindings type, please use a boolean or a bindings hash"}}this.trigger("elCreated",this._model,this._el)},removeEl:function(){if(this._modelBinder!==undefined){this._modelBinder.unbind()}this._el.remove();this.trigger("elRemoved",this._model,this._el)},isElContained:function(e){return this._el===e||$(this._el).has(e).length>0},getModel:function(){return this._model},getEl:function(){return this._el}};_.extend(t,this);return t}});Backbone.CollectionBinder.ViewManagerFactory=function(e){_.bindAll.apply(_,[this].concat(_.functions(this)));this._viewCreator=e;if(!_.isFunction(this._viewCreator))throw"viewCreator must be a valid function that accepts a model and returns a backbone view"};_.extend(Backbone.CollectionBinder.ViewManagerFactory.prototype,{setParentEl:function(e){this._parentEl=e},getParentEl:function(){return this._parentEl},makeElManager:function(e){var t={_model:e,createEl:function(){this._view=this._viewCreator(e);$(this._parentEl).append(this._view.render(this._model).el);this.trigger("elCreated",this._model,this._view)},removeEl:function(){if(this._view.close!==undefined){this._view.close()}else{this._view.$el.remove();console.log("warning, you should implement a close() function for your view, you might end up with zombies")}this.trigger("elRemoved",this._model,this._view)},isElContained:function(e){return this._view.el===e||this._view.$el.has(e).length>0},getModel:function(){return this._model},getView:function(){return this._view},getEl:function(){return this._view.$el}};_.extend(t,this);return t}})}).call(this)