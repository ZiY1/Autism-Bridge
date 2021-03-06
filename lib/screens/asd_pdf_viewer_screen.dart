import 'package:autism_bridge/models/asd_user_credentials.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/asd_pdf_export_screen.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sizer/sizer.dart';

import '../color_constants.dart';

class AsdPdfViewerScreen extends StatefulWidget {
  final AsdUserCredentials asdUserCredentials;

  final File file;

  final Resume userResume;

  const AsdPdfViewerScreen({
    Key? key,
    required this.asdUserCredentials,
    required this.file,
    required this.userResume,
  }) : super(key: key);

  @override
  State<AsdPdfViewerScreen> createState() => _AsdPdfViewerScreenState();
}

class _AsdPdfViewerScreenState extends State<AsdPdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
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
          leadingWidth: 14.8.w,
        ),
        body: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Positioned(
              child: PDFView(
                filePath: widget.file.path,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: kBackgroundRiceWhite,
          elevation: 0.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.2.h),
            child: SizedBox(
              height: 6.25.h,
              child: MyBottomButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AsdPdfExportScreen(
                        file: widget.file,
                        fileName: widget.userResume.userPersonalDetails == null
                            ? 'my_resume.pdf'
                            : '${widget.userResume.userPersonalDetails!.firstName}_${widget.userResume.userPersonalDetails!.lastName}_resume.pdf',
                        asdUserCredentials: widget.asdUserCredentials,
                        userResume: widget.userResume,
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
