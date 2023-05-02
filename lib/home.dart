import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'Model/coin_model.dart';
import 'coin_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Coin> coinList = [];
  Future<List<Coin>> fetchCoin() async {
    final Map<String, String> queryParams = {
      'vs_currency': 'usd',
      'order': 'market_cap_desc',
      'per_page': '100',
      'sparkline': 'false',
      'price_change_percentage': '24h',
    };

    final Uri uri = Uri.https(
      'api.coingecko.com',
      '/api/v3/coins/markets',
      queryParams,
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> values = jsonResponse;

      if (values.isNotEmpty) {
        List<Coin> coins = [];
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            coins.add(Coin.fromJson(map));
          }
        }
        setState(() {
          coinList = coins;
        });
        return coinList;
      } else {
        throw Exception('Failed to load the data');
      }
    } else {
      throw Exception('Failed to load the data');
    }
  }

  @override
  void initState() {
    fetchCoin();
    Timer.periodic(const Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  bool isDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = isDarkTheme ? ThemeData.dark() : ThemeData.light();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    BoxDecoration decoration;
    if (isDarkTheme) {
      decoration = BoxDecoration(
        color: Colors.grey[900],
      );
    } else {
      decoration = BoxDecoration(
        color: Colors.yellow[50],
      );
    }

    return Theme(
      data: themeData,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: decoration,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                      vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 175, 185, 115)
                        .withOpacity(0.9),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CryptoHub',
                        style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Sigmar-Regular',
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isDarkTheme = !isDarkTheme;
                          });
                        },
                        icon: Icon(
                          isDarkTheme ? Icons.wb_sunny : Icons.nightlight_round,
                          color: isDarkTheme ? Colors.white : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Hi, Welcome Back!',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'SchylerBrunoAceSC-Regular',
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                child: Row(
                  children: const [
                    Text(
                      'Today\'s Cryptocurrency Prices by Market Cap:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Expanded(
                child: FutureBuilder<List<Coin>>(
                  future: fetchCoin(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Coin>> snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return CoinCard(
                                  name: snapshot.data![index].name,
                                  symbol: snapshot.data![index].symbol,
                                  imageUrl: snapshot.data![index].imageUrl,
                                  price: snapshot.data![index].price.toDouble(),
                                  change:
                                      snapshot.data![index].change.toDouble(),
                                  changePercentage: snapshot
                                      .data![index].changePercentage
                                      .toDouble(),
                                  color: isDarkTheme
                                      ? Colors.grey[900]!
                                      : Colors.yellow[50]!,
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
