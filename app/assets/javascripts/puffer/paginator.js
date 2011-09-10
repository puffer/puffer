var Paginator = RightJS.Paginator = (function(document, Math, RightJS) {

/**
 * This module defines the basic widgets constructor
 * it creates an abstract proxy with the common functionality
 * which then we reuse and override in the actual widgets
 *
 * Copyright (C) 2010-2011 Nikolay Nemshilov
 */

/**
 * The widget units constructor
 *
 * @param String tag-name or Object methods
 * @param Object methods
 * @return Widget wrapper
 */
function Widget(tag_name, methods) {
  if (!methods) {
    methods = tag_name;
    tag_name = 'DIV';
  }

  /**
   * An Abstract Widget Unit
   *
   * Copyright (C) 2010 Nikolay Nemshilov
   */
  var AbstractWidget = new RightJS.Class(RightJS.Element.Wrappers[tag_name] || RightJS.Element, {
    /**
     * The common constructor
     *
     * @param Object options
     * @param String optional tag name
     * @return void
     */
    initialize: function(key, options) {
      this.key = key;
      var args = [{'class': 'rui-' + key}];

      // those two have different constructors
      if (!(this instanceof RightJS.Input || this instanceof RightJS.Form)) {
        args.unshift(tag_name);
      }
      this.$super.apply(this, args);

      if (RightJS.isString(options)) {
        options = RightJS.$(options);
      }

      // if the options is another element then
      // try to dynamically rewrap it with our widget
      if (options instanceof RightJS.Element) {
        this._ = options._;
        if ('$listeners' in options) {
          options.$listeners = options.$listeners;
        }
        options = {};
      }
      this.setOptions(options, this);

      return (RightJS.Wrapper.Cache[RightJS.$uid(this._)] = this);
    },

  // protected

    /**
     * Catches the options
     *
     * @param Object user-options
     * @param Element element with contextual options
     * @return void
     */
    setOptions: function(options, element) {
      if (element) {
        options = RightJS.Object.merge(options, new Function("return "+(
          element.get('data-'+ this.key) || '{}'
        ))());
      }

      if (options) {
        RightJS.Options.setOptions.call(this, RightJS.Object.merge(this.options, options));
      }

      return this;
    }
  });

  /**
   * Creating the actual widget class
   *
   */
  var Klass = new RightJS.Class(AbstractWidget, methods);

  // creating the widget related shortcuts
  RightJS.Observer.createShortcuts(Klass.prototype, Klass.EVENTS || RightJS([]));

  return Klass;
}


/**
 * The filenames to include
 *
 * Copyright (C) 2010 Nikolay Nemshilov
 */
var R       = RightJS,
    $       = RightJS.$,
    $$      = RightJS.$$,
    $w      = RightJS.$w,
    $E      = RightJS.$E,
    $A      = RightJS.$A,
    isHash  = RightJS.isHash,
    Element = RightJS.Element;


var Paginator = new Widget({
  extend: {
    version: '2.2.3',

    Options: {
      total: 1,
      current: 1,
      link: ''
    }
  },

  initialize: function() {
    var args = $A(arguments).compact(), options = args.pop(), element = args.pop();

    if (!isHash(options) || options instanceof Element) {
      element = $(element || options);
      options = {};
    }

    this.$super('paginator', element).setOptions(options);


    this.sliderValue = (this.options.current - 1) * 100 / (this.options.total - 1);
    this.sliderValue |= 0;

    this.append(
      this.wrapper = new Element('div', {'class': 'rui-paginator-pages-wrapper'}).append(this.pages = new Paginator.Pages(this)),
      this.slider = new Slider({round: 1})
    );
    this.slider.onChange(this.pages.redraw.bind(this.pages));
    this.slider.setValue(this.sliderValue);
    this.pages.redraw();
  },

  insertTo: function(element, position) {
    this.$super(element, position);
    this.slider.setValue(this.sliderValue);
    this.pages.redraw();
    return this;
  }
});

Paginator.Pages = new Class(Element, {
  initialize: function(paginator) {
    this.paginator  = paginator;
    this.options = paginator.options;

    this.$super('ul', {'class': 'rui-paginator-pages'});
  },

  redraw: function(event) {
    var value = this.paginator.slider.getValue();
    var current_page = (value * (this.options.total - 1) / 100).round() + 1;

    this.clean();
    var page = new Paginator.Page(this.paginator, current_page);
    this.append(page);

    var width = this.paginator.wrapper.dimensions().width;
    var page_width = page.dimensions().width;
    var pages_width = width - page_width/2;
    var track_point = value * pages_width / 100;

    var i = current_page - 1;
    while (i > 0 && this.dimensions().width < track_point) {
      this.insert(new Paginator.Page(this.paginator, i), 'top');
      i--;
    }

    var i = current_page + 1;
    while (i <= this.options.total && this.dimensions().width < pages_width) {
      this.append(new Paginator.Page(this.paginator, i));
      i++;
    }
  }
});

Paginator.Page = new Class(Element, {
  initialize: function(paginator, page) {
    this.paginator  = paginator;
    this.options = paginator.options;

    this.$super('li');

    if (this.options.current == page) {
      this.setClass('current');
      this.insert(new Element('span').update(page));
    } else {
      var link = {'href': '#'}
      RightJS.Object.each(this.options.link, function(key, value) {
        link[key] = value.replace('%{page}', page).replace('%25%7Bpage%7D', page);
      });

      this.insert(new Element('a', link).update(page));
    }
  }
});

$(document).on({
  ready: function() {
    $$('.rui-paginator').each(function(element) {
      if (!(element instanceof Paginator)) {
        element = new Paginator(element);
      }
    });
  }
});

return Paginator;
})(document, Math, RightJS);