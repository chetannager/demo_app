import 'package:demo_app/compass.dart';
import 'package:demo_app/providers/packageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AppInfo extends StatefulWidget {
  String packageName;
  AppInfo(this.packageName);
  @override
  _AppInfoState createState() => _AppInfoState();
}

class _AppInfoState extends State<AppInfo> {
  packageManager pm = new packageManager();
  bool isLoading = true;
  dynamic packageDetails = {};
  bool isExpand = false;
  int index = 0;
  List<String> names = [
    "Basic Information",
    "Directories",
    "Signatures",
    "Permissions",
    "Receivers",
    "Services",
    "Providers",
    "Activities",
    "Metadata",
    "Shared Libraries",
    "Native Libraries",
  ];

  void getPackageDetails() {
    print("flutter start");
    pm.getPackageDetails(widget.packageName).then((packageInfo) {
      setState(() {
        isLoading = false;
        packageDetails = packageInfo;
        print("flutter end");
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      getPackageDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Details"),
        actions: [
          IconButton(
            onPressed: () {
              pm.getBatteryLevel().then((value) => print(value));
            },
            icon: const Icon(Icons.code_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.file_copy_outlined),
          ),
          IconButton(
            onPressed: () {
              pm.launchReview(widget.packageName).then((value) => print(value));
            },
            icon: const Icon(Icons.android),
            tooltip: "Find in Market",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Compass()));
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? Center(
              child: const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 20.0),
                          alignment: Alignment.center,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Hero(
                                tag: widget.packageName.toString(),
                                child: Image.memory(
                                  packageDetails["appIcon"],
                                  width: 80,
                                ),
                              ),
                              packageDetails["isSystemApp"] ||
                                      packageDetails["isDebuggable"]
                                  ? Positioned(
                                      bottom: 5,
                                      right: -15,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  214, 48, 49, 0.2),
                                              spreadRadius: 5,
                                              blurRadius: 10,
                                              offset: Offset(0, 0),
                                            ),
                                          ],
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              Color.fromRGBO(214, 48, 49, 1.0),
                                              Color.fromRGBO(
                                                  255, 118, 117, 1.0),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          packageDetails["isSystemApp"]
                                              ? "System"
                                              : packageDetails["isDebuggable"]
                                                  ? "Debug"
                                                  : "",
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 0.3,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Text(
                            packageDetails["appName"],
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          child: Text(
                            packageDetails["packageName"],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            packageDetails["versionName"],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 17.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(
                              Icons.share_outlined,
                              size: 34.0,
                            ),
                            tooltip: "Share this App",
                            onPressed: () {
                              // Share.share("Download " +
                              //     args["appName"].toString() +
                              //     " App from Google Play. Check out https://play.google.com/store/apps/details?id=" +
                              //     args["packageId"].toString());
                            },
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.launch_outlined,
                              size: 34.0,
                            ),
                            tooltip: "Open this App",
                            onPressed: () {
                              pm
                                  .openApp(widget.packageName)
                                  .then((value) => print(value));
                            },
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 34.0,
                            ),
                            tooltip: "Uninstall this App",
                            onPressed: () {
                              pm
                                  .uninstallApp(widget.packageName)
                                  .then((value) => print(value));
                            },
                          ),
                          SizedBox(
                            width: 40.0,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              size: 34.0,
                            ),
                            tooltip: "Information this App",
                            onPressed: () {
                              pm
                                  .openAppSettings(widget.packageName)
                                  .then((value) => print(value));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: names
                                  .map((name) => Container(
                                        margin: EdgeInsets.only(right: 13),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              index = names.indexOf(name);
                                            });

                                            if (names.indexOf(name) == 3) {
                                              pm
                                                  .showToast("Permissions : " +
                                                      packageDetails[
                                                              "permissions"]
                                                          .length
                                                          .toString())
                                                  .then(
                                                      (value) => print(value));
                                            } else if (names.indexOf(name) ==
                                                4) {
                                              pm
                                                  .showToast("Receivers : " +
                                                      packageDetails[
                                                              "receivers"]
                                                          .length
                                                          .toString())
                                                  .then(
                                                      (value) => print(value));
                                            } else if (names.indexOf(name) ==
                                                5) {
                                              pm
                                                  .showToast("Services : " +
                                                      packageDetails["services"]
                                                          .length
                                                          .toString())
                                                  .then(
                                                      (value) => print(value));
                                            } else if (names.indexOf(name) ==
                                                6) {
                                              pm
                                                  .showToast("Providers : " +
                                                      packageDetails[
                                                              "providers"]
                                                          .length
                                                          .toString())
                                                  .then(
                                                      (value) => print(value));
                                            } else if (names.indexOf(name) ==
                                                7) {
                                              pm
                                                  .showToast("Activities : " +
                                                      packageDetails[
                                                              "activities"]
                                                          .length
                                                          .toString())
                                                  .then(
                                                      (value) => print(value));
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 12),
                                            decoration: BoxDecoration(
                                              color:
                                                  names.indexOf(name) == index
                                                      ? Colors.black
                                                          .withOpacity(0.06)
                                                      : Colors.black
                                                          .withOpacity(0.01),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              name.toString(),
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0.1,
                                                color: Colors.black
                                                    .withOpacity(1.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            margin: EdgeInsets.only(bottom: 13),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.06),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              children: [
                                index == 0
                                    ? Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("App Name"),
                                                subtitle: Text(
                                                    packageDetails["appName"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Package Name"),
                                                subtitle: Text(packageDetails[
                                                        "packageName"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Version Name"),
                                                subtitle: Text(packageDetails[
                                                        "versionName"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Version Code"),
                                                subtitle: Text(packageDetails[
                                                        "versionCode"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("minSdkVersion"),
                                                subtitle: Text(packageDetails[
                                                        "minSdkVersion"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("targetSdkVersion"),
                                                subtitle: Text(packageDetails[
                                                        "targetSdkVersion"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Installed on"),
                                                subtitle: Text(packageDetails[
                                                        "firstInstallTime"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Last Update"),
                                                subtitle: Text(packageDetails[
                                                        "lastUpdateTime"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Installed by"),
                                                subtitle: Text(packageDetails[
                                                        "installedBy"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("UID"),
                                                subtitle: Text(
                                                    packageDetails["uid"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Shared User ID"),
                                                subtitle: Text(packageDetails[
                                                        "sharedUserId"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("processName"),
                                                subtitle: Text(packageDetails[
                                                        "processName"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("MD5"),
                                                subtitle: Text(
                                                    packageDetails["apkMD5"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                                index == 1
                                    ? Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("publicSourceDir"),
                                                subtitle: Text(packageDetails[
                                                        "publicSourceDir"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("nativeLibraryDir"),
                                                subtitle: Text(packageDetails[
                                                        "nativeLibraryDir"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("dataDir"),
                                                subtitle: Text(
                                                    packageDetails["dataDir"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("ProtectedDataDir"),
                                                subtitle: Text(packageDetails[
                                                        "deviceProtectedDataDir"]
                                                    .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                                index == 2
                                    ? Column(
                                        children: [
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Valid From"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["before"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Valid Until"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["after"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Algorithm"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["algname"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Algorithm Id"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["sigalgoid"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Version"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["version"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Serial"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["serial"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Signature"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["signature"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Card(
                                            child: Container(
                                              child: ListTile(
                                                title: Text("Public Key"),
                                                subtitle: Text(
                                                    packageDetails["signatures"]
                                                            ["publickey"]
                                                        .toString()),
                                                onTap: () {},
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : Container(),
                                index == 3
                                    ? Column(
                                        children:
                                            packageDetails["permissions"] ==
                                                    null
                                                ? []
                                                : packageDetails["permissions"]
                                                    .map<Widget>(
                                                        (permission) => Card(
                                                              child: Container(
                                                                child: ListTile(
                                                                  subtitle: Text(
                                                                      permission
                                                                          .toString()),
                                                                  onTap: () {},
                                                                ),
                                                              ),
                                                            ))
                                                    .toList(),
                                      )
                                    : Container(),
                                index == 4
                                    ? Column(
                                        children: packageDetails["receivers"] ==
                                                null
                                            ? []
                                            : packageDetails["receivers"]
                                                .map<Widget>((receiver) => Card(
                                                      child: Container(
                                                        child: ListTile(
                                                          title: Text(
                                                              receiver["name"]
                                                                  .toString()),
                                                          subtitle: Text(receiver[
                                                                  "processName"]
                                                              .toString()),
                                                          onTap: () {},
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                      )
                                    : Container(),
                                index == 5
                                    ? Column(
                                        children: packageDetails["services"] ==
                                                null
                                            ? []
                                            : packageDetails["services"]
                                                .map<Widget>((service) => Card(
                                                      child: Container(
                                                        child: ListTile(
                                                          title: Text(
                                                              service["name"]
                                                                  .toString()),
                                                          subtitle: Text(service[
                                                                  "processName"]
                                                              .toString()),
                                                          onTap: () {},
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                      )
                                    : Container(),
                                index == 6
                                    ? Column(
                                        children: packageDetails["providers"] ==
                                                null
                                            ? []
                                            : packageDetails["providers"]
                                                .map<Widget>((provider) => Card(
                                                      child: Container(
                                                        child: ListTile(
                                                          title: Text(
                                                              provider["name"]
                                                                  .toString()),
                                                          subtitle: Text(provider[
                                                                  "processName"]
                                                              .toString()),
                                                          onTap: () {},
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                      )
                                    : Container(),
                                index == 7
                                    ? Column(
                                        children: packageDetails[
                                                    "activities"] ==
                                                null
                                            ? []
                                            : packageDetails["activities"]
                                                .map<Widget>((activity) => Card(
                                                      child: Container(
                                                        child: ListTile(
                                                          title: Text(activity[
                                                                  "taskAffinity"]
                                                              .toString()),
                                                          subtitle: Text(
                                                              activity["name"]
                                                                  .toString()),
                                                          onTap: () {},
                                                        ),
                                                      ),
                                                    ))
                                                .toList(),
                                      )
                                    : Container(),
                                index == 8
                                    ? Container(
                                        child: Card(
                                          child: Container(
                                            child: ListTile(
                                              subtitle: Text(
                                                  packageDetails["metaData"]
                                                      .toString()),
                                              onTap: () {},
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                index == 9
                                    ? Container(
                                        child: packageDetails[
                                                    "sharedLibraryFiles"] ==
                                                null
                                            ? Container()
                                            : Column(
                                                children: packageDetails[
                                                        "sharedLibraryFiles"]
                                                    .map<Widget>((data) => Card(
                                                          child: Container(
                                                            child: ListTile(
                                                              subtitle: Text(data
                                                                  .toString()),
                                                              onTap: () {},
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                      )
                                    : Container()
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
