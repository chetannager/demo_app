import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Privacy Policy"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding:
              EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "PLEASE READ THESE SERVICE TERMS AND CONDITIONS (THE ‘AGREEMENT’) IN THEIR ENTIRETY BEFORE USING OR RECEIVING ANY SERVICES (AS DEFINED BELOW) FROM APPS INFO MANAGED BY BITINFINITY WEB SOLUTIONS, INC. (THE ‘COMPANY’).",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "1. Collection of Information",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "We collect information about you and your use of our service, your interactions with us and our advertising, as well as information regarding your device. This information includes:",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 0, 0, 0.9)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      "Your activity on the Apps Info, such as see the details of Apps, search queries;",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 0, 0, 0.9)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      "device IDs or other unique identifiers, including for devices that are Apps Info use on your Wi-Fi network;",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 8.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 8.0,
                    height: 8.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(0, 0, 0, 0.9)),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Text(
                      "We collect the event log info you perform on Apps Info pages.",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "2. Use of Information",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                "We use information to provide, analyze, administer, enhance and personalize our services and marketing efforts.",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                "IF YOU DO NOT AGREE TO THE TERMS OF THIS AGREEMENT OR CANNOT MAKE ANY OF THE FOREGOING REPRESENTATIONS, YOU ARE NOT PERMITTED TO USE OR RECEIVE ANY SERVICES FROM THE COMPANY.",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
