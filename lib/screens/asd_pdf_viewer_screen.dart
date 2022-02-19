import 'package:autism_bridge/models/resume_data.dart';
import 'package:autism_bridge/screens/asd_pdf_export_screen.dart';
import 'package:autism_bridge/widgets/resume_builder_button.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class AsdPdfViewerScreen extends StatefulWidget {
  final File file;

  final Resume userResume;

  const AsdPdfViewerScreen({
    Key? key,
    required this.file,
    required this.userResume,
  }) : super(key: key);

  @override
  State<AsdPdfViewerScreen> createState() => _AsdPdfViewerScreenState();
}

class _AsdPdfViewerScreenState extends State<AsdPdfViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundRiceWhite,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: kAutismBridgeBlue,
        title: const Text(
          'Resume Preview',
        ),
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
    );
  }
}
