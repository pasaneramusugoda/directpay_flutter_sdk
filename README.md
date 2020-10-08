
# DirectPay Flutter SDK

Integrating DirectPay with your Flutter App is made easy with our DirectPay Flutter SDK. You just need to follow few simple steps. First, include the package in your project dependencies, then call its methods to initiate a payment and fetch the payment status just after the payment. DONE! and now you can enjoy the freedom of accepting payments within your flutter application. 

#GOCASHLESS

## Usage ##

See the [example](https://github.com/directpaylk/directpay_flutter_sdk_example) for better understanding. 

### Adding DirectPay SDK to your App ###

Add the following dependency to your `pubspec.yaml` file.
```yaml
dependencies:
  flutter_mpgs_sdk:
    git:
      url: git://github.com/directpaylk/directpay_flutter_sdk.git
```

Execute the command below to update your project.

```
flutter pub get
```

###  Code Setup for DirectPay Flutter Integration ### 

##### a. Main Configuration #####

Necessary imports to make it work
```dart
import 'package:flutter_mpgs_sdk/directpay_card_view.dart';
import 'package:flutter_mpgs_sdk/support.dart';
```

Call following method with Respective Parameters in your initState method of your Widget as specified.
* Replace the merchant_id with your merchant id ex: DP00001
* Set the Environment as accordingly SANDBOX or LIVE
```dart
 // Environment.SANDBOX
 // Environment.LIVE
 // Make sure you put the relevant merchant ID according the environment
 
 @override
  void initState() {
    // Replace with your merchant id here
    DirectPayCardInput.init("merchant_id",Environment.SANDBOX);
    super.initState();
  }

```

#### Callbacks ####

Add the following Callback Functions to your widget and set them as parameters to DirectPayCardInput widget

```dart
void onCloseCardForm() {
    // Triggered when CardAddForm is closed
    print("Closed");
}

void onErrorCardForm(String error,String description){
    print(error);
}

void onCompleteCardForm(
      String status,
      String transactionId,
      String description) {
    print("Status:" + status);
    print("Transaction ID:" + transactionId);
    print("Description:" + description);
}

// Set the above functions as parameters
DirectPayCardInput(
    onCloseCardForm: onCloseCardForm, // Callback for Card Input Close
    onCompleteResponse: onCompleteCardForm, // Callback for Card Input Complete
    onErrorCardForm:onErrorCardForm // Callback for Card Input Error
)
```


##### b. One Time Payment #####

Triggeres a one time payment request that charges only once.
* Set a uniquely generated value for the reference, You will be using this referece to retrive information regarding the payment
* You get Set the confirmation endpoint on directpay IPG Portal to get realtime responses from server

```dart

DirectPayCardInput.start(CardAction.ONE_TIME_PAYMENT,CardData.pay(
    amount: 10.00, //double value
    currency: PayCurrency.LKR, //enum
    reference:
    "zxywvu123456" //Unique value from merchant.
));
```

##### c. Card Add #####

Use this to Tokenize the customer card details to use later

* Set a uniquely generated value for the reference, You will be using this referece to retrive information regarding the tokenized card
* You get Set the confirmation endpoint on directpay IPG Portal to get realtime responses from server

```dart
DirectPayCardInput.start(CardAction.CARD_ADD,CardData.add(
    currency: PayCurrency.LKR,
    reference:"abcdef123456" //Unique value to identify the card holder.
));
```


#### Parameteres ####

```dart
// Triggers card input when called
DirectPayCardInput.start(CardAction action, CardData payment);

// Parameters to pass for one time payment
CardAction.ONE_TIME_PAYMENT
CardData.pay({
    @required this.currency,
    @required this.amount,
    @required this.reference,
    this.cardNickName,
    this.email,
    this.mobile,
    this.customerName,
    this.description
});

// Parameters to pass for card add
CardAction.CARD_ADD
CardData.add({
    @required this.currency,
    @required this.reference,
    this.cardNickName,
    this.email,
    this.mobile,
    this.customerName,
    this.description
  });

```

- `CardAction` - _Enumeration_
Used to define the type of action taken when `DirectPayCardInput.start()` method triggered.

- `CardData` - _Object_
Data Object that passes the relevent parameters to the Start method depending on the type of transaction


## FAQ ##

#### Flutter Support? ####

Supports Flutter Versions above `1.20.0`.

#### iOS Support? ####

Supports iOS Versions above '8.0'.

#### Android Support? #### 

Supports Android Versions above 'API Level 16'.


### MORE INFORMATION? ### 

Please Visit [doc.directpay.lk](https://doc.directpay.lk/)


