import 'package:flutter/material.dart';

// TODO: Make it dynamic with accordance to the database
// 1.) CardSavedSearch
// 2.) CardRecommendMatch
// 3.) CardRecentSearch
// 4.) CardHistorySearch

class CardSavedSearch extends StatelessWidget {
  //
  // inputs for the constructor
  final String searchedOccupation;
  final String nameOfSearch;
  final String numberOfResults;
  final String numberOfNewResults;
  final bool isNotification;

  CardSavedSearch({
    required this.nameOfSearch,
    required this.searchedOccupation,
    required this.numberOfResults,
    required this.numberOfNewResults,
    required this.isNotification,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: () {
          // TODO: ...
        },
        leading: isNotification
            ? Icon(
                Icons.notifications_outlined,
                color: Colors.blueGrey.shade700,
              )
            : Icon(
                Icons.label_important_outline,
                color: Colors.blueGrey.shade700,
              ),
        title: Text(
          "$nameOfSearch",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "$searchedOccupation\n$numberOfResults results",
          style: TextStyle(
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        trailing: Container(
          width: 72,
          height: 20,
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade700,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Center(
            child: Text(
              "$numberOfNewResults new",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StackedWidgets extends StatelessWidget {
  final List<Widget> items;
  final TextDirection direction;
  final double size;
  final double xShift;

  const StackedWidgets({
    Key? key,
    required this.items,
    this.direction = TextDirection.rtl,
    this.size = 40,
    this.xShift = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allItems = items
        .asMap()
        .map((index, item) {
          final left = size - xShift;

          final value = Container(
            width: size,
            height: size,
            child: item,
            margin: EdgeInsets.only(left: left * index),
          );

          return MapEntry(index, value);
        })
        .values
        .toList();

    return Stack(
      children: direction == TextDirection.ltr
          ? allItems.reversed.toList()
          : allItems,
    );
  }
}

class CardRecommendMatch extends StatelessWidget {
  //
  // Input info
  final String positionMatch;
  final String numberOfPositions;

  final List<Widget> mylist = [
    CircleAvatar(
      backgroundImage: AssetImage("images/blank-person.jpg"),
    ),
    CircleAvatar(
      backgroundImage: AssetImage("images/blank-person.jpg"),
    ),
    CircleAvatar(
      backgroundImage: AssetImage("images/blank-person.jpg"),
    ),
    CircleAvatar(
      backgroundImage: AssetImage("images/blank-person.jpg"),
    ),
  ];

  CardRecommendMatch({
    required this.positionMatch,
    required this.numberOfPositions,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate Device's Dimension
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final screenDeviceWidth = MediaQuery.of(context).size.width;

    return InkWell(
      splashColor: Colors.blue,
      onTap: () {
        //TODO: ...
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 0.01 * screenDeviceWidth),
        height: screenDeviceHeight * 0.2,
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: screenDeviceHeight * 0.06,
                    width: screenDeviceWidth * 0.6,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: screenDeviceHeight * 0.02,
                        left: screenDeviceWidth * 0.03,
                      ),
                      child: Text(
                        "$positionMatch",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15 * textScaleFactor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(
                  right: screenDeviceWidth * 0.35,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: screenDeviceWidth * 0.2,
                      height: screenDeviceHeight * 0.035,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade700,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          "$numberOfPositions new",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12 * textScaleFactor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.only(
                        right: screenDeviceWidth * 0.3,
                        top: screenDeviceHeight * 0.01,
                      ),
                      child: StackedWidgets(
                        items: mylist,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CardRecentSearch extends StatelessWidget {
  //
  // Input to display in the current research card
  final String recentSearchPosition;
  final String recentNumberOfFilter;
  final String recentDateStamp;

  // Constructor for the customized Card
  CardRecentSearch({
    required this.recentSearchPosition,
    required this.recentNumberOfFilter,
    required this.recentDateStamp,
  });

  //
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const ContinuousRectangleBorder(
          side: BorderSide(
        width: 1.0,
      )),
      elevation: 1.0,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              // TODO: ...
            },
            leading: Icon(
              Icons.loop,
              color: Colors.blue.shade600,
            ),
            title: Text(
              "Continue Search",
              style: TextStyle(
                color: Colors.blue.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "$recentSearchPosition  +$recentNumberOfFilter filter" +
                  "  • ${recentDateStamp as String}",
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.blueGrey.shade700,
            ),
          )
        ],
      ),
    );
  }
}

class CardHistorySearch extends StatelessWidget {
  //
  // inputs for the constructor
  final String searchedPosition;
  final String numberOfFilters;
  final String dateSearched;
  final String numberOfResults;

  CardHistorySearch({
    required this.searchedPosition,
    required this.numberOfFilters,
    required this.dateSearched,
    required this.numberOfResults,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ListTile(
        onTap: () {
          // TODO: ..
        },
        leading: Icon(
          Icons.history,
          color: Colors.blueGrey.shade700,
        ),
        title: Text(
          "$searchedPosition",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          "$numberOfFilters filters | $dateSearched\n$numberOfResults results",
          style: TextStyle(
            color: Colors.blueGrey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
        isThreeLine: true,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.blueGrey.shade700,
        ),
      ),
    );
  }
}
