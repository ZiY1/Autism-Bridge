import 'dart:typed_data';

import 'package:autism_bridge/apis/pdf_api.dart';
import 'package:autism_bridge/models/resume_data.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:http/http.dart' show get;
import 'package:sizer/sizer.dart';

const PdfColor kTitleBlue = PdfColor.fromInt(0xFF203864);
const PdfColor kTextGrey = PdfColor.fromInt(0xFF929292);
const PdfColor kBackground = PdfColor.fromInt(0xFFF2F2F2);

class ResumePdfApi {
  static Future<File> generate(Resume userResume) async {
    final resumePdf = pw.Document();

    final fontRegular = await rootBundle.load("fonts/Poppins-Regular.ttf");
    final poppinsRegular = pw.Font.ttf(fontRegular);

    final fontBold = await rootBundle.load("fonts/Poppins-Bold.ttf");
    final poppinsBold = pw.Font.ttf(fontBold);

    Uint8List profileImageData =
        userResume.userPersonalDetails!.profileImage.readAsBytesSync();

    final profileImage = pw.MemoryImage(profileImageData);

    resumePdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.standard,
          buildBackground: (pw.Context context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: kBackground),
            );
          },
        ),
        build: (context) => [
          userResume.userPersonalDetails == null
              ? pw.SizedBox.shrink()
              : buildPersonalDetails(
                  userResume, poppinsRegular, poppinsBold, profileImage),
          pw.SizedBox(height: 2.h),
          userResume.userProfessionalSummary == null
              ? pw.SizedBox.shrink()
              : buildProfessionalSummary(
                  userResume, poppinsRegular, poppinsBold),
          pw.SizedBox(height: 2.h),
          userResume.userEmploymentHistoryList.isEmpty
              ? pw.SizedBox.shrink()
              : buildEmploymentHistory(userResume, poppinsRegular, poppinsBold),
          pw.SizedBox(height: 2.h),
          userResume.userEducationList.isEmpty
              ? pw.SizedBox.shrink()
              : buildEducation(userResume, poppinsRegular, poppinsBold),
          pw.SizedBox(height: 2.h),
          userResume.userSkillList.isEmpty
              ? pw.SizedBox.shrink()
              : buildSkill(userResume, poppinsRegular, poppinsBold),
          pw.SizedBox(height: 2.h),
          userResume.userAutismChallengeList.isEmpty
              ? pw.SizedBox.shrink()
              : buildAutismChallenge(userResume, poppinsRegular, poppinsBold),
        ],
      ),
    );

    return PdfApi.saveDocument(
      name: userResume.userPersonalDetails == null
          ? 'my_resume.pdf'
          : '${userResume.userPersonalDetails!.firstName}_${userResume.userPersonalDetails!.lastName}_resume.pdf',
      pdf: resumePdf,
    );
  }

  static pw.Widget buildPersonalDetails(Resume userResume,
      pw.Font myFontRegular, pw.Font myFontBold, pw.MemoryImage profileImage) {
    return pw.Row(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              '${userResume.userPersonalDetails!.firstName} ${userResume.userPersonalDetails!.lastName}',
              style: pw.TextStyle(
                font: myFontBold,
                fontSize: 15.sp,
                color: kTitleBlue,
                //fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(vertical: 1.h),
              child: pw.SizedBox(
                width: 10.w,
                child: pw.Divider(
                  thickness: 3.5,
                  color: kTitleBlue,
                ),
              ),
            ),
            pw.Row(
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'City: ${userResume.userPersonalDetails!.city}',
                      style: pw.TextStyle(
                        font: myFontRegular,
                        fontSize: 10.sp,
                        color: kTextGrey,
                        //fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 0.7.h),
                    pw.Text(
                      'Birthday: ${userResume.userPersonalDetails!.dateOfBirth}',
                      style: pw.TextStyle(
                        font: myFontRegular,
                        fontSize: 10.sp,
                        color: kTextGrey,
                        //fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(width: 5.w),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Phone: ${userResume.userPersonalDetails!.phone}',
                      style: pw.TextStyle(
                        font: myFontRegular,
                        fontSize: 10.sp,
                        color: kTextGrey,
                        //fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 0.7.h),
                    pw.Text(
                      'email: ${userResume.userPersonalDetails!.email}',
                      style: pw.TextStyle(
                        font: myFontRegular,
                        fontSize: 10.sp,
                        color: kTextGrey,
                        //fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(width: 8.w),
        pw.SizedBox(
          width: 15.h,
          height: 15.h,
          child: pw.FittedBox(
            child: pw.Image(profileImage),
            fit: pw.BoxFit.cover,
          ),
        ),
      ],
    );
  }

  static pw.Widget buildProfessionalSummary(
      Resume userResume, pw.Font myFontRegular, pw.Font myFontBold) {
    return pw.Row(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headerSeg('Professional Summary', myFontBold),
            pw.SizedBox(
              width: 120.w,
              child: pw.Text(
                userResume.userProfessionalSummary!.summaryText,
                style: pw.TextStyle(
                  font: myFontRegular,
                  fontSize: 10.sp,
                  color: kTextGrey,
                  //fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget buildEmploymentHistory(
      Resume userResume, pw.Font myFontRegular, pw.Font myFontBold) {
    List<pw.Widget> userEmploymentWidgets = [];

    for (int i = 0; i < userResume.userEmploymentHistoryList.length; i++) {
      pw.Widget widgetTemp = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          i == 0 ? pw.SizedBox.shrink() : pw.SizedBox(height: 2.h),
          pw.SizedBox(
            width: 120.w,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  userResume.userEmploymentHistoryList[i]!.employer,
                  style: pw.TextStyle(
                    font: myFontRegular,
                    fontSize: 12.sp,
                    color: kTitleBlue,
                    //fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '${userResume.userEmploymentHistoryList[i]!.startDate} - ${userResume.userEmploymentHistoryList[0]!.endDate}',
                  style: pw.TextStyle(
                    font: myFontRegular,
                    fontSize: 12.sp,
                    color: kTitleBlue,
                    //fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(
            userResume.userEmploymentHistoryList[i]!.jobTitle,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 10.5.sp,
              color: kTitleBlue,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            userResume.userEmploymentHistoryList[i]!.city,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 10.sp,
              color: kTextGrey,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            width: 120.w,
            child: pw.Text(
              userResume.userEmploymentHistoryList[i]!.description,
              style: pw.TextStyle(
                font: myFontRegular,
                fontSize: 10.sp,
                color: kTextGrey,
                //fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      );

      userEmploymentWidgets.add(widgetTemp);
    }

    return pw.Row(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headerSeg('Employment History', myFontBold),
            pw.Column(children: userEmploymentWidgets),
          ],
        ),
      ],
    );
  }

  static pw.Widget buildEducation(
      Resume userResume, pw.Font myFontRegular, pw.Font myFontBold) {
    List<pw.Widget> userEducationWidgets = [];

    for (int i = 0; i < userResume.userEducationList.length; i++) {
      pw.Widget widgetTemp = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          i == 0 ? pw.SizedBox.shrink() : pw.SizedBox(height: 2.h),
          pw.SizedBox(
            width: 120.w,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  userResume.userEducationList[i]!.school,
                  style: pw.TextStyle(
                    font: myFontRegular,
                    fontSize: 12.sp,
                    color: kTitleBlue,
                    //fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  '${userResume.userEducationList[i]!.startDate} - ${userResume.userEducationList[0]!.endDate}',
                  style: pw.TextStyle(
                    font: myFontRegular,
                    fontSize: 12.sp,
                    color: kTitleBlue,
                    //fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          pw.Text(
            '${userResume.userEducationList[i]!.degree} of ${userResume.userEducationList[i]!.major}',
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 10.5.sp,
              color: kTitleBlue,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            userResume.userEducationList[i]!.city,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 10.sp,
              color: kTextGrey,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            width: 120.w,
            child: pw.Text(
              userResume.userEducationList[i]!.description,
              style: pw.TextStyle(
                font: myFontRegular,
                fontSize: 10.sp,
                color: kTextGrey,
                //fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      );

      userEducationWidgets.add(widgetTemp);
    }

    return pw.Row(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headerSeg('Education History', myFontBold),
            pw.Column(children: userEducationWidgets),
          ],
        ),
      ],
    );
  }

  static pw.Widget buildSkill(
      Resume userResume, pw.Font myFontRegular, pw.Font myFontBold) {
    List<pw.Widget> userSkillWidgets = [];

    for (int i = 0; i < userResume.userSkillList.length; i++) {
      pw.Widget widgetTemp = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          i == 0 ? pw.SizedBox.shrink() : pw.SizedBox(height: 2.h),
          pw.Text(
            userResume.userSkillList[i]!.skillName,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 12.sp,
              color: kTitleBlue,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            userResume.userSkillList[i]!.skillLevel,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 10.sp,
              color: kTextGrey,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            width: 120.w,
            child: pw.Text(
              userResume.userSkillList[i]!.skillDescription,
              style: pw.TextStyle(
                font: myFontRegular,
                fontSize: 10.sp,
                color: kTextGrey,
                //fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      );

      userSkillWidgets.add(widgetTemp);
    }

    return pw.Row(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headerSeg('Skills', myFontBold),
            pw.Column(children: userSkillWidgets),
          ],
        ),
      ],
    );
  }

  static pw.Widget buildAutismChallenge(
      Resume userResume, pw.Font myFontRegular, pw.Font myFontBold) {
    List<pw.Widget> userAutismChallengeWidgets = [];

    for (int i = 0; i < userResume.userAutismChallengeList.length; i++) {
      pw.Widget widgetTemp = pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          i == 0 ? pw.SizedBox.shrink() : pw.SizedBox(height: 2.h),
          pw.Text(
            userResume.userAutismChallengeList[i]!.challengeName,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 12.sp,
              color: kTitleBlue,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.Text(
            userResume.userAutismChallengeList[i]!.challengeLevel,
            style: pw.TextStyle(
              font: myFontRegular,
              fontSize: 10.sp,
              color: kTextGrey,
              //fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(
            width: 120.w,
            child: pw.Text(
              userResume.userAutismChallengeList[i]!.challengeDescription,
              style: pw.TextStyle(
                font: myFontRegular,
                fontSize: 10.sp,
                color: kTextGrey,
                //fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ],
      );

      userAutismChallengeWidgets.add(widgetTemp);
    }

    return pw.Row(
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            headerSeg('Autism Challenge', myFontBold),
            pw.Column(children: userAutismChallengeWidgets),
          ],
        ),
      ],
    );
  }

  static pw.Widget headerSeg(String headerName, pw.Font myFontBold) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          headerName,
          style: pw.TextStyle(
            font: myFontBold,
            fontSize: 13.sp,
            color: kTitleBlue,
            //fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Padding(
          padding: pw.EdgeInsets.only(
            top: 0.1.h,
            bottom: 0.6.h,
          ),
          child: pw.SizedBox(
            width: 120.w,
            child: pw.Row(
              children: [
                pw.Expanded(
                  flex: 1,
                  child: pw.Divider(
                    thickness: 3,
                    color: kTitleBlue,
                  ),
                ),
                pw.Expanded(
                  flex: 10,
                  child: pw.Padding(
                    padding: pw.EdgeInsets.only(top: 0.18.h),
                    child: pw.Divider(
                      thickness: 1.5,
                      indent: 0.58.w,
                      color: kTextGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Future<pw.PageTheme> myPageTheme(PdfPageFormat format) async {
//   //final bgShape = await rootBundle.loadString('assets/resume.svg');
//
//   final fontBold = await rootBundle.load("fonts/Poppins-Bold.ttf");
//   final poppinsBold = pw.Font.ttf(fontBold);
//
//   final fontRegular = await rootBundle.load("fonts/Poppins-Regular.ttf");
//   final poppinsRegular = pw.Font.ttf(fontRegular);
//
//   format = format.applyMargin(
//       left: 2.0 * PdfPageFormat.cm,
//       top: 4.0 * PdfPageFormat.cm,
//       right: 2.0 * PdfPageFormat.cm,
//       bottom: 2.0 * PdfPageFormat.cm);
//   return pw.PageTheme(
//     pageFormat: format,
//     theme: pw.ThemeData.withFont(
//       base: poppinsRegular,
//       bold: poppinsBold,
//       // icons: await PdfGoogleFonts.materialIcons(),
//     ),
//     buildBackground: (pw.Context context) {
//       return pw.FullPage(
//         ignoreMargins: true,
//         // child: pw.Stack(
//         //   children: [
//         //     // pw.Positioned(
//         //     //   child: pw.SvgImage(svg: bgShape),
//         //     //   left: 0,
//         //     //   top: 0,
//         //     // ),
//         //     // pw.Positioned(
//         //     //   child: pw.Transform.rotate(
//         //     //       angle: pi, child: pw.SvgImage(svg: bgShape)),
//         //     //   right: 0,
//         //     //   bottom: 0,
//         //     // ),
//         //   ],
//         // ),
//       );
//     },
//   );
// }
