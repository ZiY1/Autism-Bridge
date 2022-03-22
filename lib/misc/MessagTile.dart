import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final AssetImage profilePictureUser;
  final String firstName;
  final String lastName;
  final String lastMessage;
  final String receivedMessageDate;
  final int numberOfNewMessage;

  MessageTile({
    required this.profilePictureUser,
    required this.firstName,
    required this.lastName,
    required this.lastMessage,
    required this.receivedMessageDate,
    required this.numberOfNewMessage,
  });

  @override
  _MessageTileState createState() => _MessageTileState(
        profilePictureUser: profilePictureUser,
        firstName: firstName,
        lastName: lastName,
        lastMessage: lastMessage,
        receivedMessageDate: receivedMessageDate,
        numberOfNewMessage: numberOfNewMessage,
      );
}

class _MessageTileState extends State<MessageTile> {
  final AssetImage profilePictureUser;
  final String firstName;
  final String lastName;
  final String lastMessage;
  final String receivedMessageDate;
  final int numberOfNewMessage;

  _MessageTileState({
    required this.profilePictureUser,
    required this.firstName,
    required this.lastName,
    required this.lastMessage,
    required this.receivedMessageDate,
    required this.numberOfNewMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: InkWell(
        onTap: () {
          // TODO:...
        },
        child: Card(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: profilePictureUser,
                ),
                title: Text(
                  "$firstName $lastName",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: SizedBox(
                  child: Text(
                    "$lastMessage",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Column(
                  children: [
                    Text(
                      "$receivedMessageDate",
                    ),
                    numberOfNewMessage != 0
                        ? Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.blue.shade700,
                            ),
                            child: Text(
                              '$numberOfNewMessage',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(
                            width: 0,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckMessageBoxTile extends StatefulWidget {
  final AssetImage profilePictureUser;
  final Function UpdateNoOfSelectedTiles;
  final Function deleteSelectedTile;
  final String firstName;
  final String lastName;
  final String lastMessage;
  final String receivedMessageDate;
  final int numberOfNewMessage;
  final String deleteId;

  CheckMessageBoxTile({
    required this.UpdateNoOfSelectedTiles,
    required this.deleteSelectedTile,
    required this.deleteId,
    required this.profilePictureUser,
    required this.firstName,
    required this.lastName,
    required this.lastMessage,
    required this.receivedMessageDate,
    required this.numberOfNewMessage,
  });

  @override
  _CheckMessageBoxTileState createState() => _CheckMessageBoxTileState(
        UpdateNoOfSelectedTiles: UpdateNoOfSelectedTiles,
        deleteSelectedTile: deleteSelectedTile,
        deleteId: deleteId,
        profilePictureUser: profilePictureUser,
        firstName: firstName,
        lastName: lastName,
        lastMessage: lastMessage,
        receivedMessageDate: receivedMessageDate,
        numberOfNewMessage: numberOfNewMessage,
      );
}

class _CheckMessageBoxTileState extends State<CheckMessageBoxTile> {
  final AssetImage profilePictureUser;
  final Function UpdateNoOfSelectedTiles;
  final Function deleteSelectedTile;
  final String firstName;
  final String lastName;
  final String lastMessage;
  final String receivedMessageDate;
  final int numberOfNewMessage;
  final String deleteId;

  _CheckMessageBoxTileState({
    required this.UpdateNoOfSelectedTiles,
    required this.deleteSelectedTile,
    required this.deleteId,
    required this.profilePictureUser,
    required this.firstName,
    required this.lastName,
    required this.lastMessage,
    required this.receivedMessageDate,
    required this.numberOfNewMessage,
  });

  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      tileColor: Colors.white,
      activeColor: Colors.green,
      value: _value,
      onChanged: (bool? value) {
        setState(() {
          _value = value!;
          UpdateNoOfSelectedTiles(_value);
          deleteSelectedTile(_value, deleteId);
        });
      },
      title: Text(
        "$firstName $lastName",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: SizedBox(
        child: Text(
          "$lastMessage",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      secondary: Column(
        children: [
          Text(
            "$receivedMessageDate",
          ),
          numberOfNewMessage != 0
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade700,
                  ),
                  child: Text(
                    '$numberOfNewMessage',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container(
                  width: 0,
                ),
        ],
      ),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
