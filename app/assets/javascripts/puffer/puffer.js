var association_done = function(event) {
  current = this.first('li.current');
  this.input.next('input[type=hidden]').value(current.get('data-id'));
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

  dialog.load(this.get('data-dialog-uri'));
});

'a[data-new-dialog-uri]'.on('click', function(event) {
  console.log(event )
  if (event.which != 1) return;
  event.stop();

  new Dialog({expandable: true}).load(this.get('data-new-dialog-uri'));
});