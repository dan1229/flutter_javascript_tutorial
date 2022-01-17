/*
 *  ====================================================
 *  Copyright (c) 2021. Daniel Nazarian
 *
 *  Do not use, edit or distribute without explicit permission.
 *  Questions, comments or concerns -> email dnaz@danielnazarian.com
 * ======================================================
 */

// coverage:ignore-file_
@JS()
library braintree_payment;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
// ignore: implementation_imports
import 'package:flutter_braintree/src/request.dart';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

// EXTERNAL JAVASCRIPT ==========================================

@JS()
external void initBraintree(auth);

@JS()
external payment(String auth);

// ==============================================================
// FLUTTER BRAINTREE WEB ========================================
// ==============================================================

class BraintreeWidget extends StatefulWidget {
  const BraintreeWidget();

  @override
  _BraintreeWidgetState createState() => _BraintreeWidgetState();

  Future<BraintreeDropInResult?> start(BuildContext context, BraintreeDropInRequest request) async {
    // create div with html embedded
    String htmlL = """<div id="checkout-message"></div>
        <div id="dropin-container"></div>
    <button id="submit-button">Submit payment</button>""";
    var paymentDiv = html.DivElement()..appendHtml(htmlL);

    // attach to payment container
    ui.platformViewRegistry.registerViewFactory('braintree-container', (int viewId) => paymentDiv);

    // show dialog
    Future dialogResponse = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select assignment'),
          children: <Widget>[
            Container(child: this),
          ]
        );
      }
    );
    
    // call js function
    var promise = payment(request.clientToken ?? "");
    String? nonce = await promiseToFuture(promise);

    // close dialog
    Navigator.pop(
      context,
    );

    // return nonce
    if (nonce != null) {
      BraintreePaymentMethodNonce btNonce = BraintreePaymentMethodNonce(nonce: nonce, typeLabel: 'Visa', description: 'Visa ending in', isDefault: false);
      return BraintreeDropInResult(paymentMethodNonce: btNonce, deviceData: null);
    } else {
      // DIALOG CLOSED OR NONCE INVALID
      return null;
    }
  }
}

class _BraintreeWidgetState extends State<BraintreeWidget> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: SizedBox(
        width: 600.0,
        height: 300.0,
        child: HtmlElementView(
          viewType: 'braintree-container',
        ),
      ),
    );
  }
}
