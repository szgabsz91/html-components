import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('h-masked-input')
class MaskedInputComponent extends PolymerElement {
  
  @published String mask;
  @published String placeholder = '_';
  @published String value = '';
  
  bool get isValid => !value.contains(placeholder);
  
  static final String LETTER = 'a';
  static final String NUMBER = '9';
  
  MaskedInputComponent.created() : super.created();
  
  @override
  void enteredView() {
    super.enteredView();
    
    _refreshInputField();
  }
  
  void onInputKeyDown(KeyboardEvent event) {
    // Arrow
    if (event.which >= 37 && event.which <= 40) {
      // Normal behavior
    }
    // Enter
    else if (event.which == 13) {
      if (!isValid) {
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
      int currentIndex = $['input'].selectionStart;
      int previousIndex = _getPreviousIndex(currentIndex);
      _placeCursor(previousIndex + 1);
    }
    // Del
    else if (event.which == 46) {
      int currentIndex = $['input'].selectionStart;
      
      if (currentIndex >= mask.length) {
        event.preventDefault();
        return;
      }
      
      int nextIndex = _getNextFilledCharacterIndex(currentIndex);
      _placeCursor(nextIndex);
    }
  }
  
  void onInputKeyUp(KeyboardEvent event) {
    int currentIndex = $['input'].selectionStart;
    
    // Don't do anything at the beginning and end of the string
    if (currentIndex == 0 || currentIndex >= mask.length) {
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
  
  void onInputClicked() {
    if ($['input'].value == mask.replaceAll(new RegExp(r'[a9]'), placeholder)) {
      _placeCursor(0);
    }
  }
  
  void onInputBlur() {
    if (!$['input'].value.contains(placeholder)) {
      value = $['input'].value;
      
      this.dispatchEvent(new Event('valueChanged'));
    }
  }
  
  void _onAlphaNumericKeyDown(KeyboardEvent event, bool characterFilter(int index)) {
    int currentIndex = $['input'].selectionStart;
    
    if (currentIndex >= mask.length) {
      event.preventDefault();
      return;
    }
    
    if (characterFilter(currentIndex) && $['input'].value[currentIndex] != placeholder) {
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
      if ($['input'].value[i] != mask[i] || [LETTER, NUMBER].contains($['input'].value[i])) {
        return i;
      }
    }
    
    return -1;
  }
  
  int _getNextIndex(int currentIndex) {
    for (int i = currentIndex; i < mask.length; ++i) {
      if ($['input'].value[i] == placeholder) {
        return i;
      }
    }
    
    return -1;
  }
  
  int _getNextPlaceholderIndexInBlock(int currentIndex) {
    for (int i = currentIndex; i < mask.length; ++i) {
      if ($['input'].value[i] == placeholder) {
        return i;
      }
      
      if ($['input'].value[i] == mask[i] && ![LETTER, NUMBER].contains(mask[i])) {
        break;
      }
    }
    
    return -1;
  }
  
  int _getNextFilledCharacterIndex(int currentIndex) {
    for (int i = currentIndex; i < mask.length; ++i) {
      if ($['input'].value[i] != mask[i] || [LETTER, NUMBER].contains($['input'].value[i])) {
        return i;
      }
    }
    
    return -1;
  }
  
  void _removeCharacterAtIndex(int index) {
    $['input'].value = $['input'].value.substring(0, index) + $['input'].value.substring(index + 1);
  }
  
  void _insertPlaceholderAtIndex(int index) {
    $['input'].value = $['input'].value.substring(0, index) + placeholder + $['input'].value.substring(index);
  }
  
  bool _isCharacterNumeric(int index) {
    return mask[index] == NUMBER;
  }
  
  bool _isCharacterLetter(int index) {
    return mask[index] == LETTER;
  }
  
  void _placeCursor(int index) {
    $['input']
      ..selectionStart = index
      ..selectionEnd = index;
  }
  
  void _refreshInputField() {
    value = mask.replaceAll(new RegExp(r'[a9]'), placeholder);
  }
  
}