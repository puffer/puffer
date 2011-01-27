/**
 * The Ruby On Rails plugin for RightJS
 * http://github.com/MadRabbit/right-rails
 *
 * Copyright (C) 2009-2010 Nikolay Nemshilov
 */
(function(window, document, RightJS) {
/**
 * Underscored aliases for Ruby On Rails
 *
 * Copyright (C) 2009-2010 Nikolay Nemshilov
 */

/**
 * The Rails plugin initialization script
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */

var R      = RightJS,
    $      = RightJS.$,
    $$     = RightJS.$$,
    $E     = RightJS.$E,
    Xhr    = RightJS.Xhr,
    Object = RightJS.Object;



// the language and window level aliases
R([
  RightJS.String.prototype,
  RightJS.Array.prototype,
  RightJS.Function.prototype,
  RightJS.Object,
  RightJS.Options,
  RightJS.Observer,
  RightJS.Observer.prototype,
  window,
  document
]).each(function(object) {
  for (var key in object) {
    try { // some keys are not accessable
      
      if (/[A-Z]/.test(key) && typeof(object[key]) === 'function') {
        var u_key = R(key).underscored();
        if (object[u_key] === null || object[u_key] === undefined) {
          object[u_key] = object[key];
        }
      }
    } catch (e) {}
  }
});


// DOM package aliases
R([
  RightJS.Element,
  RightJS.Event,
  RightJS.Form,
  RightJS.Input
]).each(function(object) {
  if (!object) { return; }
  
  var aliases = {}, methods = object.prototype;
    
  for (var key in methods) {
    if (/[A-Z]/.test(key) && typeof(methods[key]) === 'function') {
      object.prototype[R(key).underscored()] = methods[key];
    }
  }
});

// various ruby-like method aliases
RightJS.$alias(RightJS.String.prototype, {
  index_of:      'indexOf',
  last_index_of: 'lastIndexOf',
  to_f:          'toFloat',
  to_i:          'toInt',
  gsub:          'replace',
  downcase:      'toLowerCase',
  upcase:        'toUpperCase',
  index:         'indexOf',
  rindex:        'lastIndexOf',
  strip:         'trim'
});

RightJS.$alias(RightJS.Array.prototype, {
  collect:       'map',
  detect:        'filter',
  index_of:      'indexOf',
  last_index_of: 'lastIndexOf',
  index:         'indexOf',
  rindex:        'lastIndexOf'
});

/**
 * Rails 3 UJS support module
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */
(function() {
  // tries to cancel the event via confirmation
  var user_cancels = function(event, element) {
    var message = element.get('data-confirm');
    if (message && !confirm(message)) {
      event.stop();
      return true;
    }
  };
  
  // adds XHR events to the element
  var add_xhr_events = function(element, options) {
    return Object.merge({
      onCreate:   function() { element.fire('ajax:loading',  this); },
      onComplete: function() { element.fire('ajax:complete', this); },
      onSuccess:  function() { element.fire('ajax:success',  this); },
      onFailure:  function() { element.fire('ajax:failure',  this); }
    }, options);
  };
  
  // processes link clicks
  var try_link_submit = function(event) {
    var link   = event.target,
        method = link.get('data-method'),
        remote = link.get('data-remote'),
        url    = link.get('href');
    
    if (user_cancels(event, link)) { return; }
    if (method || remote) { event.stop(); }
    
    if (remote) {
      Xhr.load(url, add_xhr_events(link, {
        method:     method || 'get',
        spinner:    link.get('data-spinner')
      }));
      
    } else if (method) {
      var param = $$('meta[name=csrf-param]')[0],
          token = $$('meta[name=csrf-token]')[0],
          form  = $E('form', {action: url, method: 'post'});
      
      if (param && token) {
        form.insert('<input type="hidden" name="'+param.get('content')+'" value="'+token.get('content')+'" />');
      }
      
      form.insert('<input type="hidden" name="_method" value="'+method+'"/>')
        .insertTo(document.body).submit();
    }
  };

  // global events listeners
  $(document).on({
    click: function(event) {
      var tag = event.target._.tagName;
      if (tag === 'A' || tag === 'BUTTON') {
        try_link_submit(event);
      }
    },
    
    submit: function(event) {
      var form = event.target;
      if (form.has('data-remote') && !user_cancels(event, form)) {
        event.stop();
        form.send(add_xhr_events(form, {
          spinner:  form.get('data-spinner') || form.first('.spinner')
        }));
      }
    }
  });
})();


/**
 * RR is the common ajax operations wrapper for ruby on rails
 *
 * Copyright (C) 2009-2010 Nikolay Nemshilov
 */
var RR = {
  /**
   * Basic options
   *
   * NOTE: DO NOT CHANGE this hash right here
   *       Use your application.js file to alter the options
   */
  Options: {
    format:           'js',      // the working format for remote requests over the application
    
    flashId:          'flashes', // the flashes element id
    flashHideFx:      'slide',   // use null if you don't want any fx in here
    flashHideDelay:   3200,      // use -1 to disable the flash element hidding
    
    highlightUpdates: true,
    
    removeFx:         'fade',    // blocks removing fx
    insertFx:         'fade',    // blocks insertion fx
    
    insertPosition:   'bottom',  // default insert position
    
    linkToAjaxEdit:   '.ajax_edit',
    linkToAjaxDelete: '.ajax_delete',
    
    rescanWithScopes: true       // if it should rescan only updated elements
  },
  
  /**
   * Updates the flashes block with the source
   *
   * @param String new content
   * @return RR this
   */
  update_flash: function(content) {
    var element = $(this.Options.flashId);
    if (element) {
      this.replace(element, content).hide_flash();
    }
    return this;
  },
  
  /**
   * Initializes the delayed flashes hide call
   *
   * @return RR this
   */
  hide_flash: function() {
    if (this.Options.flashHideDelay > -1) {
      var element = $(this.Options.flashId);
      if (element && element.visible()) {
        element.hide.bind(element, this.Options.flashHideFx).delay(this.Options.flashHideDelay);
      }
    }
    return this;
  },
  
  /**
   * Highlights the element according to the options
   * 
   * @param String element id
   * @return RR this
   */
  highlight: function(id) {
    if ($(id) && this.Options.highlightUpdates) {
      $(id).highlight();
    }
    return this;
  },
  
  /**
   * Inserts the content into the given element
   *
   * @param destination String destination id
   * @param content String content
   * @param position String position
   * @return RR this
   */
  insert: function(where, what, in_position) {
    var position  = in_position || this.Options.insertPosition, new_element,
        container = $(where).insert(what, position);
    
    // trying to find the new block
    switch (position) {
      case 'bottom':  new_element = container.children().last(); break;
      case 'top':     new_element = container.first(); break;
      case 'before':  new_element = container.prev();  break;
      case 'after':   new_element = container.next();  break;
    }
    
    // necely displaying the new block
    if (new_element && this.Options.insertFx) {
      new_element.hide().show(this.Options.insertFx, {
        onFinish: this.highlight.bind(this, new_element)
      });
    } else {
      this.highlight(new_element);
    }
    
    return this.rescan(where);
  },
  
  /**
   * Replaces the given element with a new content
   *
   * @param destination String destination id
   * @param content String content
   * @return RR this
   */
  replace: function(id, source) {
    $(id).replace(source);
    return this.highlight(id).rescan(id);
  },
  
  /**
   * removes the element by id
   *
   * @param String element id
   * @return RR this
   */
  remove: function(id) {
    if ($(id)) {
      $(id).remove(this.Options.removeFx);
    }
  },
  
  /**
   * Makes a remote form out of the form
   *
   * @param String form id
   * @return RR this
   */
  remotize_form: function(id) {
    var form = $(id);
    if (form) {
      form.remotize().enable()._.action += '.'+this.Options.format;
    }
    return this;
  },
  
  /**
   * Replaces the form with new content and makes it remote
   *
   * @param form id String form id
   * @param content String content
   * @return RR this
   */
  replace_form: function(id, source) {
    var form = $(id);
    if (form) {
      form.replace(source);
      this.remotize_form(id);
    }
    
    return this.rescan(id);
  },
  
  /**
   * Inserts the form source into the given element
   *
   * @param target id String target id
   * @param source String form source
   * @return RR this
   */
  show_form_for: function(id, source) {
    $(id).select('form').each('remove'); // removing old forms
    $(id).insert(source);
    
    return this.remotize_form($(id).first('form')).rescan(id);
  },
  
  /**
   * watches link clicks and processes the ajax edit/delete operations
   *
   * @param Event event
   */
  process_click: function(event) {
    var link;
    
    if ((link = event.find('a'+ this.Options.linkToAjaxEdit))) {
      event.stop();
      Xhr.load(link.get('href') + '.' + this.Options.format);
    } else if ((link = event.find('a'+ this.Options.linkToAjaxDelete)) && link.has('onclick')) {
      event.stop();
      eval('({f:'+ link.onclick.toString().replace('.submit', '.send')+'})').f.call(link);
    }
  },
  
  /**
   * Scans for updated elements
   *
   * @return RR this
   */
  rescan: function(scope) {
    $w('Draggable Droppable Tabs Slider Selectable').each(function(name) {
      if (name in window) {
        window[name].rescan(this.Options.rescanWithScopes ? scope : null);
      }
    }, this);
    
    
    return this;
  }
};


/**
 * the document onload hooks
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */
$(document).on({
  ready: function() {
    RR.hide_flash();
  },
  
  click: function(event) {
    RR.process_click(event);
  }
});
  
window.RR = RR;
})(window, document, RightJS);