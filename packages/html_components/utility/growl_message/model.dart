import 'package:polymer/polymer.dart';

class GrowlMessageModel extends Object with Observable {
  @observable String summary;
  @observable String detail;
  @observable String severity;
  
  GrowlMessageModel(this.summary, this.detail, this.severity);
  
  @override
  String toString() => "GrowlMessageModel[summary=${summary}, detail=${detail}, severity=${severity}]";
}