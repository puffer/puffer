var association_done = function(event) {
  current = this.first('li.current');
  this.input.next('input[type=hidden]').value(current.get('data-id'));
  this.input.value(current.find('.title').first().html().stripTags()).disable();
}

'.association_clear'.on('click', function(event) {
  this.prev('input[type=text]').value('').enable();
  this.next('input[type=hidden]').value('');
});
