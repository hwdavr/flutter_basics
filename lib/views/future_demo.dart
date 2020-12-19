import 'dart:async';
import 'dart:convert'; //This allows us to convert the returned JSON data into something Dart can use.
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FuturePage extends StatefulWidget {
  const FuturePage({Key key}) : super(key: key);

  @override
  _FuturePageState createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  var _country = "Unknown";
  AsyncMemoizer _memoizer;

  _updateCountry(country) {
    setState(() {
      this._country = country;
    });
  }

  Future _getCountry(country) async {
    String countryUrl = 'https://restcountries.eu/rest/v2/name/$country';

    try {
      _updateCountry('Loading...');
      http.Response response = await http.get(countryUrl);
      Object decoded = jsonDecode(response.body)[0]['name'];
      print('_getCountry: $decoded');
      _updateCountry(decoded);
    } catch (e) {
      throw (e);
    }
  }

  Future _getCountryWithMemoizer(country) async {
    return this._memoizer.runOnce(() async {
      // This below code will call only ones. This will return the same data directly without performing any Future task.
      String countryUrl = 'https://restcountries.eu/rest/v2/name/$country';

      try {
        http.Response response = await http.get(countryUrl);
        Object decoded = jsonDecode(response.body)[0]['name'];
        print('_getCountryString: $decoded');
        return decoded;
      } catch (e) {
        throw (e);
      }
    });
  }

  _testFuturesOrder() {
    // Based on the Future() creation order
    Future f2 = Future(() => null);
    Future f1 = Future(() => null);
    Future f3 = Future(() => null);
    f1.then((_) => print("1"));
    f2.then((_) => print("2"));
    f3.then((_) => print("3"));
  }

  _testMicrotaskAndFuturesOrder() {
    // Execution order: Main > MicroTask > EventQueue
    print('main #1 of 2');
    scheduleMicrotask(() => print('microtask #1 of 2'));

    new Future.delayed(
        new Duration(seconds: 1), () => print('future #1 (delayed)'));
    new Future(() => print('future #2 of 3'));
    new Future(() => print('future #3 of 3'));

    scheduleMicrotask(() => print('microtask #2 of 2'));

    print('main #2 of 2');
  }

  @override
  void initState() {
    super.initState();
    _memoizer = AsyncMemoizer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Future Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FutureBuilder will be executed every time setState() is called,
            // use AsyncMemoizer inside _getCountryString() to prevent API is
            // called multiple times
            FutureBuilder(
              future: _getCountryWithMemoizer('singapore'),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                // 请求已结束
                if (snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // 请求失败，显示错误
                    return Text("Error: ${snapshot.error}");
                  } else {
                    // 请求成功，显示数据
                    return Text("Country: ${snapshot.data}");
                  }
                } else {
                  // 请求未结束，显示loading
                  return CircularProgressIndicator();
                }
              },
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                '$_country',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            MaterialButton(
              onPressed: () => _getCountry('singapore'),
              child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(15),
                  child: Text('Get Country',
                      style: TextStyle(color: Colors.white))),
            ),
            MaterialButton(
              onPressed: _testFuturesOrder,
              child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(15),
                  child: Text('Test Order 1',
                      style: TextStyle(color: Colors.white))),
            ),
            MaterialButton(
              onPressed: _testMicrotaskAndFuturesOrder,
              child: Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(15),
                  child: Text('Test Order 2',
                      style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }
}
