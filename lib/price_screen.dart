import 'dart:io';

import 'package:bitcointicker/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  var coinData = CoinData();
  String selectedCurrency = currenciesList.first;
  Map<String, String> exchangeRates = Map();

  CupertinoPicker iOSPicker() {
    List<Text> menuItems = [];
    for (var currency in currenciesList) {
      menuItems.add(Text('$currency'));
    }

    return CupertinoPicker(
      looping: true,
      useMagnifier: true,
      itemExtent: 40.0,
      backgroundColor: Colors.lightBlue,
      children: menuItems,
      onSelectedItemChanged: (index) {
        getExchangeRates(currenciesList[index]);
      },
    );
  }

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> menuItems = [];
    for (var currency in currenciesList) {
      menuItems.add(
        DropdownMenuItem(
          child: Text('$currency'),
          value: currency,
        ),
      );
    }

    return DropdownButton(
        value: selectedCurrency,
        items: menuItems,
        onChanged: (value) {
          getExchangeRates(value);
        });
  }

  void getExchangeRates(value) async {
    var updatedRates = await coinData.getAllExchangeRates(value);
    setState(() {
      selectedCurrency = value;
      exchangeRates = updatedRates;
    });
  }

  void initializeExchangeRateStrings() {
    for (var item in cryptoList) {
      exchangeRates[item] = '1 $item = ? $selectedCurrency';
    }
  }

  List<Widget> getDisplayCryptoCards() {
    List<Widget> cryptoItems = [];
    for (var item in cryptoList) {
      cryptoItems.add(
        Padding(
          padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          child: Card(
            color: Colors.lightBlueAccent,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text(
                exchangeRates[item] ?? '1 $item = ? $selectedCurrency',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return cryptoItems;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeExchangeRateStrings();
    getExchangeRates(currenciesList.first);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getDisplayCryptoCards(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
