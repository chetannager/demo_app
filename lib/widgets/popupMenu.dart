import 'package:demo_app/contact.dart';
import 'package:demo_app/privacypolicy.dart';
import 'package:demo_app/providers/packageManager.dart';
import 'package:flutter/material.dart';

class popupMenu extends StatelessWidget {
  const popupMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(value: "1", child: Text("Rate Us")),
        PopupMenuItem<String>(value: "2", child: Text("More Apps")),
        PopupMenuItem<String>(value: "3", child: Text("Share this App")),
        PopupMenuItem<String>(value: "4", child: Text("Privacy Policy")),
        PopupMenuItem<String>(value: "5", child: Text("Terms & Conditions")),
      ],
      offset: Offset(50, 15),
      onSelected: (selected) {
        if (selected == '1') {
          final packageManager pm = new packageManager();
          pm
              .launchReview("com.bitinfinity.cowin")
              .then((value) => print(value));
        } else if (selected == "2") {
          final packageManager pm = new packageManager();
          pm.moreApps().then((value) => print(value));
        } else if (selected == "3") {
          final packageManager pm = new packageManager();
          pm.share("Hello", "Share this App").then((value) => print(value));
        } else if (selected == "4") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PrivacyPolicy()));
        } else if (selected == "5") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Contact()));
        }
      },
      onCanceled: () {
        print("Cancelled");
      },
      //onSelected: goToQrCode,
      tooltip: "More Options",
    );
  }
}
