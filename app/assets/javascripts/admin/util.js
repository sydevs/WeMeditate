
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

// Taken from https://stackoverflow.com/a/7478420
function getSelectionTextInfo(el) {
  var atStart = false, atEnd = false;
  var selRange, testRange;
  if (window.getSelection) {
      var sel = window.getSelection();
      if (sel.rangeCount) {
          selRange = sel.getRangeAt(0);
          testRange = selRange.cloneRange();

          testRange.selectNodeContents(el);
          testRange.setEnd(selRange.startContainer, selRange.startOffset);
          atStart = (testRange.toString() == "");

          testRange.selectNodeContents(el);
          testRange.setStart(selRange.endContainer, selRange.endOffset);
          atEnd = (testRange.toString() == "");
      }
  } else if (document.selection && document.selection.type != "Control") {
      selRange = document.selection.createRange();
      testRange = selRange.duplicate();

      testRange.moveToElementText(el);
      testRange.setEndPoint("EndToStart", selRange);
      atStart = (testRange.text == "");

      testRange.moveToElementText(el);
      testRange.setEndPoint("StartToEnd", selRange);
      atEnd = (testRange.text == "");
  }

  return { atStart: atStart, atEnd: atEnd };
}

function generateId() {
  // Math.random should be unique because of its seeding algorithm.
  // Convert it to base 36 (numbers + letters), and grab the first 16 characters after the decimal.
  return Math.random().toString(36).substr(2, 18)
}