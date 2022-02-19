import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageWidget extends StatelessWidget {
  final File image;
  //final ValueChanged<ImageSource> onClicked;
  final Function onClicked;

  const ImageWidget({
    Key? key,
    required this.image,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          buildImage(context),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(Colors.blue.shade900),
          ),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    final imagePath = this.image.path;
    final image = imagePath.contains("https://")
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath));

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image as ImageProvider,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
          child: InkWell(
            onTap: () async {
              final source = await showImageSource(context);
              if (source == null) return;
              onClicked(source, context);
            },
          ),
        ),
      ),
    );
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isAndroid) {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Camera"),
                    onTap: () => Navigator.of(context).pop(
                      ImageSource.camera,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Gallery"),
                    onTap: () => Navigator.of(context).pop(
                      ImageSource.gallery,
                    ),
                  ),
                ],
              ));
    }
  }

  Widget buildEditIcon(Color color) {
    return buildCircleIcon(
      child: buildCircleIcon(
          color: color,
          all: 8,
          child: Icon(
            Icons.add_photo_alternate,
            size: 20,
            color: Colors.white,
          )),
      all: 3,
      color: Colors.white,
    );
  }

  Widget buildCircleIcon(
      {required Widget child, required double all, required Color color}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}

class ProfilePictureWidget extends StatelessWidget {
  final String userUrlProfilePicture;
  final Function onClicked;

  const ProfilePictureWidget({
    Key? key,
    required this.userUrlProfilePicture,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          buildImage(context),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(Colors.blue.shade900),
          ),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context) {
    final profilePic = NetworkImage(userUrlProfilePicture);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: profilePic,
          fit: BoxFit.cover,
          width: 160,
          height: 160,
          child: InkWell(
            onTap: () async {
              final source = await showImageSource(context);
              if (source == null) return;
              onClicked(source, context);
            },
          ),
        ),
      ),
    );
  }

  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isAndroid) {
      return showModalBottomSheet(
          context: context,
          builder: (context) => Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text("Camera"),
                    onTap: () => Navigator.of(context).pop(
                      ImageSource.camera,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.image),
                    title: Text("Gallery"),
                    onTap: () => Navigator.of(context).pop(
                      ImageSource.gallery,
                    ),
                  ),
                ],
              ));
    }
  }

  Widget buildEditIcon(Color color) {
    return buildCircleIcon(
      child: buildCircleIcon(
          color: color,
          all: 8,
          child: Icon(
            Icons.add_photo_alternate,
            size: 20,
            color: Colors.white,
          )),
      all: 3,
      color: Colors.white,
    );
  }

  Widget buildCircleIcon(
      {required Widget child, required double all, required Color color}) {
    return ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
  }
}
