import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'components/back_card_view.dart';
import 'components/front_card_view.dart';
import 'components/input_view_pager.dart';
import 'components/reset_button.dart';
import 'components/round_button.dart';
import 'constants/captions.dart';
import 'constants/constanst.dart';
import 'model/card_info.dart';
import 'provider/card_cvv_provider.dart';
import 'provider/card_name_provider.dart';
import 'provider/card_number_provider.dart';
import 'provider/card_valid_provider.dart';
import 'provider/state_provider.dart';

typedef CardInfoCallback = void Function(
    InputState currentState, CardInfo cardInfo);

class CreditCardInputForm extends StatelessWidget {
  CreditCardInputForm(
      {required this.onStateChange,
      this.cardHeight,
      required this.frontCardDecoration,
      required this.backCardDecoration,
      this.showResetButton = true,
      required this.customCaptions,
      this.nextButtonTextStyle = kDefaultButtonTextStyle,
      this.prevButtonTextStyle = kDefaultButtonTextStyle,
      this.resetButtonTextStyle = kDefaultButtonTextStyle,
      this.nextButtonDecoration = defaultNextPrevButtonDecoration,
      this.prevButtonDecoration = defaultNextPrevButtonDecoration,
      this.resetButtonDecoration = defaultResetButtonDecoration,
      required this.processing,
      this.hasError = false});

  final CardInfoCallback onStateChange;
  final double? cardHeight;
  final BoxDecoration frontCardDecoration;
  final BoxDecoration backCardDecoration;
  final bool showResetButton;
  final Map<String, String> customCaptions;
  final BoxDecoration nextButtonDecoration;
  final BoxDecoration prevButtonDecoration;
  final BoxDecoration resetButtonDecoration;
  final TextStyle nextButtonTextStyle;
  final TextStyle prevButtonTextStyle;
  final TextStyle resetButtonTextStyle;
  bool processing, hasError;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => StateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardNumberProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardNameProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardValidProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CardCVVProvider(),
        ),
        Provider(
          create: (_) => Captions(customCaptions: customCaptions),
        ),
      ],
      child: CreditCardInputImpl(
        onCardModelChanged: onStateChange,
        backDecoration: backCardDecoration,
        frontDecoration: frontCardDecoration,
        cardHeight: cardHeight,
        showResetButton: showResetButton,
        prevButtonDecoration: prevButtonDecoration,
        nextButtonDecoration: nextButtonDecoration,
        resetButtonDecoration: resetButtonDecoration,
        prevButtonTextStyle: prevButtonTextStyle,
        nextButtonTextStyle: nextButtonTextStyle,
        resetButtonTextStyle: resetButtonTextStyle,
        processing: processing,
        hasError: hasError,
      ),
    );
  }
}

class CreditCardInputImpl extends StatefulWidget {
  final CardInfoCallback onCardModelChanged;
  final double? cardHeight;
  final BoxDecoration frontDecoration;
  final BoxDecoration backDecoration;
  final bool showResetButton;
  final BoxDecoration nextButtonDecoration;
  final BoxDecoration prevButtonDecoration;
  final BoxDecoration resetButtonDecoration;
  final TextStyle nextButtonTextStyle;
  final TextStyle prevButtonTextStyle;
  final TextStyle resetButtonTextStyle;
  bool processing, hasError;

  CreditCardInputImpl(
      {required this.onCardModelChanged,
      this.cardHeight,
      required this.showResetButton,
      required this.frontDecoration,
      required this.backDecoration,
      required this.nextButtonTextStyle,
      required this.prevButtonTextStyle,
      required this.resetButtonTextStyle,
      required this.nextButtonDecoration,
      required this.prevButtonDecoration,
      required this.resetButtonDecoration,
      required this.processing,
      required this.hasError});

  @override
  _CreditCardInputImplState createState() => _CreditCardInputImplState();
}

class _CreditCardInputImplState extends State<CreditCardInputImpl> {
  final PageController pageController = PageController(
    viewportFraction: 0.92,
    initialPage: 0,
  );

  final GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  final cardHorizontalpadding = 12;
  final cardRatio = 16.0 / 9.0;

  var _currentState = InputState.NUMBER;

  @override
  Widget build(BuildContext context) {
    final newState = Provider.of<StateProvider>(context).getCurrentState();

    final name = Provider.of<CardNameProvider>(context).cardName;

    final cardNumber = Provider.of<CardNumberProvider>(context).cardNumber;

    final valid = Provider.of<CardValidProvider>(context).cardValid;

    final cvv = Provider.of<CardCVVProvider>(context).cardCVV;

    final captions = Provider.of<Captions>(context);

    if (newState != _currentState) {
      _currentState = newState;

      Future(() {
        widget.onCardModelChanged(
            _currentState,
            CardInfo(
                name: name, cardNumber: cardNumber, validate: valid, cvv: cvv));
      });
    }

    double cardWidth =
        MediaQuery.of(context).size.width - (2 * cardHorizontalpadding);

    double cardHeight;
    if (widget.cardHeight != null && widget.cardHeight! > 0) {
      cardHeight = widget.cardHeight!;
    } else {
      cardHeight = cardWidth / cardRatio;
    }

    final frontDecoration = widget.frontDecoration != null
        ? widget.frontDecoration
        : defaultCardDecoration;
    final backDecoration = widget.backDecoration != null
        ? widget.backDecoration
        : defaultCardDecoration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FlipCard(
            speed: 300,
            flipOnTouch: _currentState == InputState.CVV,
            key: cardKey,
            front:
                FrontCardView(height: cardHeight, decoration: frontDecoration),
            back: BackCardView(height: cardHeight, decoration: backDecoration),
          ),
        ),
        widget.processing
            ? Container()
            : Stack(
                children: [
                  AnimatedOpacity(
                    opacity: _currentState == InputState.DONE ? 0 : 1,
                    duration: Duration(milliseconds: 500),
                    child: InputViewPager(
                      pageController: pageController,
                    ),
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: AnimatedOpacity(
                          opacity: widget.showResetButton &&
                                  _currentState == InputState.DONE
                              ? 1
                              : 0,
                          duration: Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ResetButton(
                              decoration: widget.resetButtonDecoration,
                              textStyle: widget.resetButtonTextStyle,
                              onTap: () {
                                if (!widget.showResetButton) {
                                  return;
                                }

                                try {
                                  Provider.of<StateProvider>(context,
                                          listen: false)
                                      .moveFirstState();
                                } catch (e) {}

                                pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeIn);

                                if (!cardKey.currentState!.isFront) {
                                  cardKey.currentState!.toggleCard();
                                }
                              },
                            ),
                          ))),
                ],
              ),
        widget.hasError
            ? Container()
            : widget.processing
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text("Processing..."),
                        SizedBox(
                          height: 10,
                        ),
                        mounted ? CircularProgressIndicator() : Container()
                      ],
                    ),
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                    Widget>[
                    AnimatedOpacity(
                      opacity: _currentState == InputState.NUMBER ||
                              _currentState == InputState.DONE
                          ? 0
                          : 1,
                      duration: Duration(milliseconds: 500),
                      child: RoundButton(
                          decoration: widget.prevButtonDecoration,
                          textStyle: widget.prevButtonTextStyle,
                          buttonTitle: captions.getCaption('PREV'),
                          onTap: () {
                            if (InputState.DONE == _currentState) {
                              return;
                            }

                            if (InputState.NUMBER != _currentState) {
                              pageController.previousPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            }

                            if (InputState.CVV == _currentState) {
                              cardKey.currentState!.toggleCard();
                            }
                            try {
                              Provider.of<StateProvider>(context, listen: false)
                                  .movePrevState();
                            } catch (e) {}
                          }),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    AnimatedOpacity(
                      opacity: _currentState == InputState.DONE ? 0 : 1,
                      duration: Duration(milliseconds: 500),
                      child: RoundButton(
                          decoration: widget.nextButtonDecoration,
                          textStyle: widget.nextButtonTextStyle,
                          buttonTitle: _currentState == InputState.CVV ||
                                  _currentState == InputState.DONE
                              ? captions.getCaption('DONE')
                              : captions.getCaption('NEXT'),
                          onTap: () {
                            if (InputState.CVV != _currentState) {
                              pageController.nextPage(
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.easeIn);
                            }

                            if (InputState.VALIDATE == _currentState) {
                              cardKey.currentState!.toggleCard();
                            }

                            try {
                              Provider.of<StateProvider>(context, listen: false)
                                  .moveNextState();
                            } catch (e) {}
                          }),
                    ),
                    SizedBox(
                      width: 25,
                    )
                  ]),
      ],
    );
  }
}
