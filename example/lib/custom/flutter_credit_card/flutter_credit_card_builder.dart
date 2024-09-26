part of 'flutter_credit_card.dart';

class FlutterCreditCardBuilder extends WidgetBuilder {
  FlutterCreditCardBuilder(super.application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return StatelessWidget(builder: (context) {
      return FlutterCreditCardWidget();
    });
  }
}
