import 'dart:convert';
import 'package:demo_app/appInfo.dart';
import 'package:demo_app/providers/packageManager.dart';
import 'package:demo_app/widgets/popupMenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

packageManager pm = new packageManager();

dynamic fib(bool n) async {
  print("function start");
  const platform = const MethodChannel('com.test/test');
  // if (n < 2) {
  //   return n;
  // }
  //
  // return fib(n - 2) + fib(n - 1);
  print("function end");
  return await platform.invokeMethod("getInstalledList", {"systemApps": n});
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  dynamic _allApps;
  bool isGrid = false;
  bool systemApp = false;

  void initialize(systemApp) {
    setState(() {
      isLoading = true;
    });
    print("flutter start");
    compute<bool, dynamic>(fib, systemApp).then((value) {
      setState(() {
        _allApps = value;
        print("flutter end");
      });
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      initialize(systemApp);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("isLoading" + isLoading.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text("Apps Info"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                systemApp = !systemApp;
              });
              initialize(systemApp);
            },
            icon: systemApp ? Icon(Icons.android) : Icon(Icons.apps),
            tooltip: systemApp ? "User Apps" : "All Apps",
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              pm
                  .getInstalledPackages(false)
                  .then((value) => print(value[0]["appName"]));
            },
            tooltip: "Search Apps",
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: isGrid ? Icon(Icons.list) : Icon(Icons.grid_view),
            tooltip: isGrid ? "Switch to List" : "Switch to Grid",
          ),
          popupMenu(),
        ],
      ),
      body: isLoading
          ? Center(
              child: SizedBox(
                width: 45,
                height: 45,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                ),
              ),
            )
          : isGrid
              ? GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (2 / 1),
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  //physics:BouncingScrollPhysics(),
                  padding: EdgeInsets.all(10.0),
                  children: _allApps
                      .map<Widget>(
                        (package) => Card(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Hero(
                                  tag: package["packageName"].toString(),
                                  child: Image.memory(
                                    package["appIcon"],
                                    width: 40,
                                  ),
                                ),
                                Text(package["appName"].toString(),
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black),
                                    textAlign: TextAlign.center)
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              : ListView.builder(
                  itemCount: _allApps.length,
                  itemBuilder: (context, item) => ListTile(
                    leading: Hero(
                      tag: _allApps[item]["packageName"].toString(),
                      child: Image.memory(
                        _allApps[item]["appIcon"],
                        width: 40,
                      ),
                    ),
                    title: Text(_allApps[item]["appName"]),
                    subtitle: Text(_allApps[item]["packageName"]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AppInfo(_allApps[item]["packageName"])));
                    },
                  ),
                ),
    );
  }
}
