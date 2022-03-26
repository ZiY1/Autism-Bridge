import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../color_constants.dart';

class AsdJobAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TabController? _tabController;
  final List<Tab> jobTextList;
  final AppBar appBar;

  const AsdJobAppBar({
    Key? key,
    required TabController? tabController,
    required this.jobTextList,
    required this.appBar,
  })  : _tabController = tabController,
        super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true, // Required
            unselectedLabelColor: Colors.white.withOpacity(0.8),
            unselectedLabelStyle: TextStyle(
              fontSize: 11.7.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              letterSpacing: 0.3,
            ),
            labelPadding:
                EdgeInsets.symmetric(horizontal: 1.5.h), // Space between tabs
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
              letterSpacing: 0.3,
            ),
            tabs: jobTextList,
          ),
        ],
      ),
      backgroundColor: kAutismBridgeBlue,
    );
  }
}
