import 'package:flutter/material.dart';

import 'package:autism_bridge/widgets/SignedEmployerHomeCardWidgets.dart';

class EmployerHomeTabSearch extends StatefulWidget {
  static String routeName = "Recuiter_MainPage";
  @override
  _EmployerHomeTabSearchState createState() => _EmployerHomeTabSearchState();
}

class _EmployerHomeTabSearchState extends State<EmployerHomeTabSearch> {
  @override
  Widget build(BuildContext context) {
    // Calculate Device's Dimension
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final screenDeviceHeight = MediaQuery.of(context).size.height;
    final screenDeviceWidth = MediaQuery.of(context).size.width;

    // Assuming we got the Name of the user and userId
    // Extract the data coming from the previous page (mainly: user's credentials)
    //final routeArgs =
    //    ModalRoute.of(context)?.settings.arguments as Map<String, String>;

    String nameOfRecruiter =
        "{Recruiter Name}"; //routeArgs['firstName'] as String;
    String recruiterEmail = "email";
    //routeArgs['userEmail'] as String;

    // Assuming we got the profile picture of that user
    Image profilePictureUser = Image.asset("assets/images/blank-person.jpg");

    // Assuming we got the recent Search info of that user from the FireBase
    String recentPositionSearched = "Software Engineer";
    String recentFilterUsed = "8";
    String recentDateStamp = "11:39 a.m";

    // Assuming we got the recommended matches (Always 4 )
    List<Widget> recommendedList = [
      CardRecommendMatch(
          positionMatch: "Customer Service Specialist",
          numberOfPositions: "25"),
      CardRecommendMatch(
          positionMatch: "Marketing Consultant", numberOfPositions: "12"),
      CardRecommendMatch(
          positionMatch: "Customer Service Specialist",
          numberOfPositions: "20"),
      CardRecommendMatch(
          positionMatch: "Marketing Consultant", numberOfPositions: "22")
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.symmetric(
            horizontal: screenDeviceWidth * 0.05,
            vertical: screenDeviceHeight * 0.01,
          ),
          child: InkWell(
            onTap: () {
              // TODO: ...
            },
            child: CardRecentSearch(
              recentSearchPosition: recentPositionSearched,
              recentNumberOfFilter: recentFilterUsed,
              recentDateStamp: recentDateStamp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: screenDeviceWidth * 0.05, bottom: 0),
          child: Row(
            children: [
              Text(
                "Recommended matches",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: textScaleFactor * 20,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 0.2 * screenDeviceHeight, // 0.2
          padding: EdgeInsets.only(
            left: screenDeviceWidth * 0.03,
            bottom: screenDeviceHeight * 0.01,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: recommendedList,
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          height: screenDeviceHeight * 0.35,
          child: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                toolbarHeight: screenDeviceHeight * 0.035,
                automaticallyImplyLeading: false,
                title: TabBar(
                  labelColor: Colors.blue.shade700,
                  unselectedLabelColor: Colors.blueGrey,
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: textScaleFactor * 17,
                  ),
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: [
                    Tab(
                      text: "Saved Search",
                    ),
                    Tab(
                      text: "History",
                    ),

                    ///
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  Container(
                    color: Colors.grey.shade200,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: getTheSavedSearchList(),
                    ),
                  ),
                  Container(
                    color: Colors.grey.shade200,
                    child: ListView(
                      scrollDirection: Axis.vertical,
                      children: getTheHistoryList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

List<Widget> getTheHistoryList() {
  List<Widget> listOfSearchedHistoryItems = [
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    ),
    CardHistorySearch(
      searchedPosition: "Software Engineer",
      numberOfFilters: "4",
      dateSearched: "11:30 a.m",
      numberOfResults: "1234",
    )
  ];

  return listOfSearchedHistoryItems;
}

List<Widget> getTheSavedSearchList() {
  List<Widget> listOfSavedSearchItems = [
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: true,
    ),
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: false,
    ),
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: false,
    ),
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: true,
    ),
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: false,
    ),
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: true,
    ),
    CardSavedSearch(
      nameOfSearch: "Reverse Engineer Search",
      searchedOccupation: "Software Engineer for Q4",
      numberOfResults: "1234",
      numberOfNewResults: "23",
      isNotification: false,
    ),
  ];
  return listOfSavedSearchItems;
}
