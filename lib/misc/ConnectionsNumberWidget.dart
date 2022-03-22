import 'package:flutter/material.dart';

class ConnectionsNumberWidget extends StatelessWidget {
  //final String numberOfConnections;
  final String numberOfPosts;

  ConnectionsNumberWidget({
    required this.numberOfPosts,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildSection(context, numberOfPosts, 'Posts'),
        ],
      ),
    );
  }

  Widget buildSection(BuildContext context, String valueNumber, String label) {
    return MaterialButton(
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            valueNumber,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue.shade900,
            ),
          ),
          SizedBox(),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
