library maskedinput;

import "package:web_ui/web_ui.dart";
import "dart:html";
import "dart:async";

part "maskedinput/model.dart";

class MaskedInputComponent extends WebComponent {
  MaskedInputModel model = new MaskedInputModel();
  
  static final String LETTER = "a";
  static final String NUMBER = "9";
  
  InputElement get _inputField => this.query("input.x-maskedinput_ui-inputmask");
  
  static const EventStreamProvider<Event> _VALUE_CHANGED_EVENT = const EventStreamProvider<Event>("valueChanged");
  Stream<Event> get onValueChanged => _VALUE_CHANGED_EVENT.forTarget(this);
  static void _dispatchValueChangedEvent(Element element) {
    element.dispatchEvent(new Event("valueChanged"));
  }
  
  String get mask => model.mask;
  set mask(String mask) {
    model.mask = mask;
    _refreshInputField();
  }
  
  String get placeholderchar => model.placeholderChar;
  set placeholderchar(String placeholderchar) {
    model.placeholderChar = placeholderchar;
    _refreshInputField();
  }
  
  String get value => model.value;
  set value(String value) => model.value = value;
  
  void _onKeyDown(KeyboardEvent event) {
    // Arrow
    if (event.which >= 37 && event.which <= 40) {
      // Normal behavior
    }
    // Enter
    else if (event.which == 13) {
      if (!model.isValid) {
        event.preventDefault();
      }
    }
    // Letter
    else if ((event.which >= 65 && event.which <= 95) || [186, 187, 191, 192, 219, 220, 221, 226].contains(event.which)) {
      _onAlphaNumericKeyDown(event, _isCharacterLetter);
    }
    // Number
    else if ((event.which >= 96 && event.which <= 105) || (event.which >= 48 && event.which <= 57)) {
      _onAlphaNumericKeyDown(event, _isCharacterNumeric);
    }
    // Backspace
    else if (event.which == 8) {
      int currentIndex = _inputField.selectionStart;
      int previousIndex = _getPreviousIndex(currentIndex);
      _placeCursor(previousIndex + 1);
    }
    // Del
    else if (event.which == 46) {
      int currentIndex = _inputField.selectionStart;
      
      if (currentIndex >= model.mask.length) {
        event.preventDefault();
        return;
      }
      
      int nextIndex = _getNextFilledCharacterIndex(currentIndex);
      _placeCursor(nextIndex);
    }
  }
  
  void _onKeyUp(KeyboardEvent event) {
    int currentIndex = _inputField.selectionStart;
    
    // Don't do anything at the beginning and end of the string
    if (currentIndex == 0 || currentIndex >= model.mask.length) {
      event.preventDefault();
      return;
    }
    
    // Backspace
    if (event.which == 8) {
      _insertPlaceholderAtIndex(currentIndex);
      _placeCursor(currentIndex);
    }
    // Del
    else if (event.which == 46) {
      _insertPlaceholderAtIndex(currentIndex);
      _placeCursor(currentIndex);
    }
  }
  
  void _onClicked() {
    if (_inputField.value == model.mask.replaceAll(new RegExp(r"[a9]"), model.placeholderChar)) {
      _placeCursor(0);
    }
  }
  
  void _onBlurred() {
    if (!_inputField.value.contains(model.placeholderChar)) {
      model.value = _inputField.value;
      _dispatchValueChangedEvent(this);
    }
  }
  
  void _onAlphaNumericKeyDown(KeyboardEvent event, bool characterFilter(int index)) {
    int currentIndex = _inputField.selectionStart;
    
    if (currentIndex >= model.mask.length) {
      event.preventDefault();
      return;
    }
    
    if (characterFilter(currentIndex) && _inputField.value[currentIndex] != model.placeholderChar) {
      int nextIndex = _getNextPlaceholderIndexInBlock(currentIndex);
      
      if (nextIndex > -1) {
        _removeCharacterAtIndex(nextIndex);
        _placeCursor(currentIndex);
      }
      else {
        event.preventDefault();
      }
    }
    else {
      int nextIndex = _getNextIndex(currentIndex);
      
      if (nextIndex > -1 && characterFilter(nextIndex)) {
        _removeCharacterAtIndex(nextIndex);
        _placeCursor(nextIndex);
      }
      else {
        event.preventDefault();
      }
    }
  }
  
  int _getPreviousIndex(int currentIndex) {
    for (int i = currentIndex - 1; i >= 0; --i) {
      if (_inputField.value[i] != model.mask[i] || [LETTER, NUMBER].contains(_inputField.value[i])) {
        return i;
      }
    }
    
    return -1;
  }
  
  int _getNextIndex(int currentIndex) {
    for (int i = currentIndex; i < model.mask.length; ++i) {
      if (_inputField.value[i] == model.placeholderChar) {
        return i;
      }
    }
    
    return -1;
  }
  
  int _getNextPlaceholderIndexInBlock(int currentIndex) {
    for (int i = currentIndex; i < model.mask.length; ++i) {
      if (_inputField.value[i] == model.placeholderChar) {
        return i;
      }
      
      if (_inputField.value[i] == model.mask[i] && ![LETTER, NUMBER].contains(model.mask[i])) {
        break;
      }
    }
    
    return -1;
  }
  
  int _getNextFilledCharacterIndex(int currentIndex) {
    for (int i = currentIndex; i < model.mask.length; ++i) {
      if (_inputField.value[i] != model.mask[i] || [LETTER, NUMBER].contains(_inputField.value[i])) {
        return i;
      }
    }
    
    return -1;
  }
  
  void _removeCharacterAtIndex(int index) {
    _inputField.value = _inputField.value.substring(0, index) + _inputField.value.substring(index + 1);
  }
  
  void _insertPlaceholderAtIndex(int index) {
    _inputField.value = _inputField.value.substring(0, index) + model.placeholderChar + _inputField.value.substring(index);
  }
  
  bool _isCharacterNumeric(int index) {
    return model.mask[index] == NUMBER;
  }
  
  bool _isCharacterLetter(int index) {
    return model.mask[index] == LETTER;
  }
  
  void _placeCursor(int index) {
    _inputField
      ..selectionStart = index
      ..selectionEnd = index;
  }
  
  void _refreshInputField() {
    model.value = model.mask.replaceAll(new RegExp(r"[a9]"), model.placeholderChar);
    
    _placeCursor(0);
  }
}