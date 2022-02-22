import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/asd_pdf_export_screen.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class AsdPdfViewerScreen extends StatefulWidget {
  final File file;

  final Resume userResume;

  final String userFirstName;

  final String userLastName;

  final String userEmail;

  final String userId;

  const AsdPdfViewerScreen({
    Key? key,
    required this.file,
    required this.userResume,
    required this.userFirstName,
    required this.userLastName,
    required this.userEmail,
    required this.userId,
  }) : super(key: key);

  @override
  State<AsdPdfViewerScreen> createState() => _AsdPdfViewerScreenState();
}

class _AsdPdfViewerScreenState extends State<AsdPdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0.01,
            0.25,
          ],
          colors: [
            Color(0xFFE7F0F9),
            //kAutismBridgeBlue,
            kBackgroundRiceWhite,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Resume Preview',
            style: TextStyle(
              color: kTitleBlack,
            ),
          ),
          iconTheme: const IconThemeData(
            color: kTitleBlack,
          ),
          leading: RoundedIconContainer(
            childIcon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: kTitleBlack,
              size: 20,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.w,
        ),
        body: PDFView(
          filePath: widget.file.path,
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.2.h),
            child: SizedBox(
              height: 6.25.h,
              child: ResumeBuilderButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AsdPdfExportScreen(
                        file: widget.file,
                        fileName: widget.userResume.userPersonalDetails == null
                            ? 'my_resume.pdf'
                            : '${widget.userResume.userPersonalDetails!.firstName}_${widget.userResume.userPersonalDetails!.lastName}_resume.pdf',
                        userId: widget.userId,
                        userFirstName: widget.userFirstName,
                        userLastName: widget.userLastName,
                        userEmail: widget.userEmail,
                      ),
                    ),
                  );
                },
                isHollow: false,
                child: Text(
                  'Export This PDF',
                  style: TextStyle(
                    fontSize: 12.5.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
