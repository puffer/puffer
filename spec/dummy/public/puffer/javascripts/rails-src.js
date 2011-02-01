(function(window, document, RightJS) {

  var $      = RightJS.$,
      $$     = RightJS.$$,
      $E     = RightJS.$E,
      Xhr    = RightJS.Xhr;

  var cancel = function(element) {
    var message = element.get('data-confirm');
    return(message && !confirm(message));
  }

  var xhr_events = function(element, options) {
    return Object.merge({
      onCreate:   function() { element.fire('ajax:loading',  this); },
      onComplete: function() { element.fire('ajax:complete', this); },
      onSuccess:  function() { element.fire('ajax:success',  this); },
      onFailure:  function() { element.fire('ajax:failure',  this); }
    }, options);
  };

  'form[data-remote]'.on('submit', function(event) {
    event.stop();
    this.send();
  });

  'a[data-confirm], a[data-method], a[data-remote]'.on('click', function(event) {
    if (cancel(this)) { event.stop(); return; }

    var method = this.get('data-method') || 'get',
        remote = !!this.get('data-remote'),
        url = this.get('href');

    if (method != 'get' || remote) { event.stop(); }

    if (remote) {
      Xhr.load(url, xhr_events(this, {
        method:     method,
        spinner:    this.get('data-spinner')
      }));
    }

    if (method != 'get') {
      var param = $$('meta[name=csrf-param]')[0].get('content'),
          token = $$('meta[name=csrf-token]')[0].get('content'),
          form  = $E('form', {action: url, method: 'post'});

      if (param && token) {
        form.insert('<input type="hidden" name="' + param + '" value="' + token + '" />');
      }

      form.insert('<input type="hidden" name="_method" value="' + method + '"/>')
        .insertTo(document.body).submit();
    }
  });

})(window, document, RightJS);
