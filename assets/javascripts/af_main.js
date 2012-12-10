function toggle_multi_select(el) {
  var select = $(el);
  if (select.multiple == true) {
    select.multiple = false;
	select.size = false;
  } else {
    select.multiple = true;
	select.size = 10;
  }
}	