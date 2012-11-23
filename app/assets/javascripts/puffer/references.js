'a[data-references-one-clear]'.on('click', function(event) {
  if (event.which != 1) return;
  event.stop();

  this.setStyle('display', 'none');

  var id_field = this.siblings('[data-role=references_one_id]').first();
  id_field.value('');

  var autocomplete_field = this.siblings("[data-role=references_one_autocomplete]").first();
  autocomplete_field.value("");
  autocomplete_field.set("disabled", false);
  autocomplete_field.focus();
});

var references_one_autocomplete_done = function(event) {
  var item = event.item;
  event.target.input.set("disabled", true);

  var autocomplete_field = event.target.input;
  var id_field = autocomplete_field.siblings("[data-role=references_one_id]").first();

  id_field.value(item.data("id"));
  autocomplete_field.value(item.data("title"))
  autocomplete_field.siblings("[data-role=references_one_clear]").first().setStyle('display', 'block');
}

Autocompleter.include({
  done: function(current) {
    current = current || this.first('li.current');

    if (current) {
      current.radioClass('current');
      this.input.setValue(current._.textContent || current._.innerText);
      this.fire('done', {item: current});
    }

    return this.hide();
  }
})