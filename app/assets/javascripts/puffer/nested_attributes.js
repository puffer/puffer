"a[data-insert]".on('click', function(event) {
  if (event.which != 1) return;

  if (this.data('insert').element) {
    var new_id = new Date().getTime();
    $(this.data('insert').element).insert(this.data('insert').content.replace(/new_nested_index/g, new_id));
  }
  if (this.data('insert').remove) {
    $(this.data('insert').remove).remove();
  }
  if (this.data('insert').show) {
    $(this.data('insert').show).show();
  }
  if (this.data('insert').hide) {
    $(this.data('insert').hide).hide();
  }
  event.stop();
});