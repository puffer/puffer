var association_done = function(event) {
  current = this.first('li.current');
  this.input.next('input[type=hidden]').value(current.data('id'));
  this.input.value(current.find('.title').first().html().stripTags()).disable();
}

'.association_clear'.on('click', function(event) {
  this.prev('input[type=text]').value('').enable();
  this.next('input[type=hidden]').value('');
});

'a[data-dialog-uri]'.on('click', function(event) {
  if (event.which != 1) return;
  event.stop();

  var dialog = event.find('.rui-dialog');
  if (!dialog || !(dialog instanceof Dialog)) {
    dialog = new Dialog({expandable: true});
  }

  dialog.load(this.data('dialog-uri'));
});

'a[data-new-dialog-uri]'.on('click', function(event) {
  if (event.which != 1) return;
  event.stop();

  new Dialog({expandable: true}).load(this.get('data-new-dialog-uri'));
});

'a[data-sortable]'.on('mousedown', function(event) {
  if (event.which != 1) return;

  new Sortable(this, this.data('sortable'));
});

$(document).on('ready', function(event) {
  $$('[data-sortable]').each(function(element) {
    new Sortable(element);
  });
});

$(document).on('ctrl+s', function(event) {
  $$('form[data-send]').each(function(element) {
    element.fire('submit');
    element.send({
      onComplete: function() {
        $(document).fire('ajax:complete', {xhr: this});
      }
    });
  });
  event[0].stop();
});
