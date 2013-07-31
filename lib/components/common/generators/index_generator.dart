part of generators;

int _startFromZeroGenerator(int i) {
  return i;
}

int _startFromOneGenerator(int i) {
  return i + 1;
}

List<int> getIndices(int count, {bool startFromZero: false}) {
  Function generator;
  
  if (startFromZero) {
    generator = _startFromZeroGenerator;
  }
  else {
    generator = _startFromOneGenerator;
  }
  
  return new Iterable<int>.generate(count, generator)
                          .toList(growable: false);
}