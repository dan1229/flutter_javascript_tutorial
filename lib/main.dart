import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:flutter_javascript_tutorial/widgets/braintree/braintree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String clientToken = "TEST";

  String getTotal() {
    return "1.00";
  }

  bool isWeb() {
    return kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter / JS Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter/JS Tutorial',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialogBraintree(),
        tooltip: 'Increment',
        child: const Icon(Icons.attach_money),
      ),
    );
  }

  showDialogBraintree() async {
        BraintreeDropInRequest request = BraintreeDropInRequest(
          clientToken: clientToken,
          collectDeviceData: true,
          venmoEnabled: true,
          cardEnabled: true,
          amount: getTotal(),
          googlePaymentRequest: BraintreeGooglePaymentRequest(
            currencyCode: 'USD',
            billingAddressRequired: false,
            totalPrice: getTotal(),
          ),
        );
        BraintreeDropInResult? braintreeResult;
        if (isWeb()) {
          // WEB VERSION =================================/
          braintreeResult = await BraintreeWidget().start(context, request);
        } else {
          // MOBILE VERSION ===================================/
          braintreeResult = await BraintreeDropIn.start(request);
        }
  }
}
