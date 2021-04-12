import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownValue = 'USD';

  DropdownButton getAndroidDropDown() {
    List<DropdownMenuItem<String>> dropDownItem = [];
    for (String currency in currenciesList) {
      dropDownItem.add(
        DropdownMenuItem<String>(
          child: SizedBox(
            width: 100.0,
            child: Text(
              currency,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          value: currency,
        ),
      );
    }
    return DropdownButton<String>(
      dropdownColor: Colors.lightBlueAccent,
      value: dropDownValue,
      items: dropDownItem,
      onChanged: (currency) {
        setState(() {
          dropDownValue = currency;
          getDetails();
        });
      },
    );
  }

  CupertinoPicker getiOSDropDown() {
    List<Text> dropDownItem = [];
    for (String currency in currenciesList) {
      dropDownItem.add(
        Text(currency),
      );
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        print(index);
        getDetails();
      },
      children: dropDownItem,
    );
  }

  Map<String, String> cryptoPrices = {};
  bool isLoading = true;

  void getCrypto() async {
    CoinData data = CoinData();
    cryptoPrices = await data.getCoinData(dropDownValue);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCrypto();
  }

  Column getDetails() {
    List<CryptoCard> cryptoCards = [];
    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          fromCrypto: crypto,
          toCrypto: dropDownValue,
          cryptoValue: isLoading ? '?' : cryptoPrices[crypto],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
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
          getDetails(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 90.0, vertical: 30.0),
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30.0),
            ),
            alignment: Alignment.center,
            child: Platform.isIOS ? getiOSDropDown() : getAndroidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    this.cryptoValue,
    this.toCrypto,
    this.fromCrypto,
  });

  final String cryptoValue;
  final String toCrypto;
  final String fromCrypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            '1 $fromCrypto = $cryptoValue $toCrypto',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
