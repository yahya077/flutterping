part of '../flutter_credit_card.dart';

//TODO pre construction
class FlutterCreditCardWidget extends material.StatefulWidget {
  const FlutterCreditCardWidget({
    material.Key? key,
  }) : super(key: key);

  @override
  NeedsValueNotifierState<FlutterCreditCardWidget> createState() =>
      _DotsIndicatorState();
}

class _DotsIndicatorState
    extends NeedsValueNotifierState<FlutterCreditCardWidget> {
  final material.GlobalKey<material.FormState> formKey =
      material.GlobalKey<material.FormState>();
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  @override
  material.Widget build(material.BuildContext context) {
    return material.Column(
      children: [
        CreditCardWidget(
          enableFloatingCard: useFloatingAnimation,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
          bankName: 'Axis Bank',
          showBackView: isCvvFocused,
          obscureCardNumber: true,
          obscureCardCvv: true,
          isHolderNameVisible: true,
          isSwipeGestureEnabled: true,
          onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
        ),
        const material.SizedBox(height: 20),
        CreditCardForm(
          formKey: formKey,
          obscureCvv: true,
          obscureNumber: true,
          cardNumber: cardNumber,
          cvvCode: cvvCode,
          isHolderNameVisible: true,
          isCardNumberVisible: true,
          isExpiryDateVisible: true,
          cardHolderName: cardHolderName,
          expiryDate: expiryDate,
          onCreditCardModelChange: onCreditCardModelChange,
        ),
      ],
    );
  }

  @override
  void registerNotifiers() {
    //TODO set notifiers if needed
    notifiers = [];
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
