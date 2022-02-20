import 'package:flutter/material.dart';

class NotificationIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback onTap;
  final int notificationCount;
  final Color colorChoosen;
  final double sizeChoosen;
  final double topPosition;
  const NotificationIcon({
    Key? key,
    required this.onTap,
    required this.text,
    required this.iconData,
    required this.topPosition,
    required this.colorChoosen,
    required this.sizeChoosen,
    required this.notificationCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  iconData,
                  color: colorChoosen,
                  size: sizeChoosen,
                ),
                Text(text, overflow: TextOverflow.ellipsis),
              ],
            ),
            Positioned(
              top: topPosition,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text(
                  '$notificationCount',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
