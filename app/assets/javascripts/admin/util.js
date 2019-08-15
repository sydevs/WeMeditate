
// Taken from https://stackoverflow.com/a/512542
function setCaretPosition(elem, caretPos = 0) {
  if (elem != null) {
    if (elem.createTextRange) {
      var range = elem.createTextRange();
      range.move('character', caretPos);
      range.select();
    } else {
      if (elem.selectionStart) {
        elem.focus();
        elem.setSelectionRange(caretPos, caretPos);
      } else {
        elem.focus();
      }
    }
  }
}

function generateId() {
  // Math.random should be unique because of its seeding algorithm.
  // Convert it to base 36 (numbers + letters), and grab the first 16 characters after the decimal.
  return Math.random().toString(36).substr(2, 18)
}