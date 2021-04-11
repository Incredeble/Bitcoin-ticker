import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String dropDownValue = 'USD';
  List<Widget> card;

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

  void getDetails() {
    card.add(cards(cryptoList[0], dropDownValue, cryptoPrices[cryptoList[0]]));
    card.add(cards(cryptoList[1], dropDownValue, cryptoPrices[cryptoList[1]]));
    card.add(cards(cryptoList[2], dropDownValue, cryptoPrices[cryptoList[2]]));
  }

  Widget cards(String fromCrypto, String toCrypto, String cryptoValue) {
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
          child: isLoading
              ? '?'
              : Text(
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
