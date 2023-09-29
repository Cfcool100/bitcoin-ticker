import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  Map<String, String>? cryptoPrices;
  String? bitcoinValue;
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getRateCoin(selectedCurrency);
      isWaiting = false;
      setState(() {
        cryptoPrices = data;
      });
    } catch (e) {
      print("$e yo");
    }
  }

  // String cryptoCoin = 'BTC';

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: cryptoList
                .map(
                  (coin) => RateCard(
                      cryptoCoin: coin,
                      bitcoinValue: cryptoPrices != null
                          ? cryptoPrices![coin] ?? '?'
                          : '?',
                      selectedCurrency: selectedCurrency),
                )
                .toList(),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? CupertinoPicker(
                    backgroundColor: Colors.lightBlue,
                    itemExtent: 32,
                    onSelectedItemChanged: (itemValue) {
                      setState(() {
                        selectedCurrency = currenciesList[itemValue];
                        getData();
                      });
                    },
                    children: List.generate(
                      currenciesList.length,
                      (index) => Center(
                        child: Text(currenciesList[index]),
                      ),
                    ),
                  )
                : DropdownButton<String>(
                    value: selectedCurrency,
                    items: currenciesList
                        .map<DropdownMenuItem<String>>((currency) {
                      return DropdownMenuItem<String>(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(
                        () {
                          selectedCurrency = value!;
                          getData();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class RateCard extends StatelessWidget {
  const RateCard({
    super.key,
    required this.bitcoinValue,
    required this.selectedCurrency,
    required this.cryptoCoin,
  });

  final String bitcoinValue;
  final String selectedCurrency;
  final String cryptoCoin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 10),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCoin = $bitcoinValue $selectedCurrency',
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
