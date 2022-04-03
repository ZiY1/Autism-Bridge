import 'package:google_place/google_place.dart';
import 'package:autism_bridge/widgets/my_gradient_container.dart';
import 'package:autism_bridge/widgets/rounded_icon_container.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../color_constants.dart';
import '../num_constants.dart';

class GooglePlacesSearchScreen extends StatefulWidget {
  final String title;
  final String? userInput;
  final String hintText;

  const GooglePlacesSearchScreen({
    required this.userInput,
    required this.title,
    required this.hintText,
    Key? key,
  }) : super(key: key);

  @override
  _GooglePlacesSearchScreenState createState() =>
      _GooglePlacesSearchScreenState();
}

class _GooglePlacesSearchScreenState extends State<GooglePlacesSearchScreen> {
  final GooglePlace googlePlace =
      GooglePlace('AIzaSyCaHYNzsSQ5HllIpifWYFztyIoM8OUzT9M');

  List<AutocompletePrediction> predictions = [];

  final TextEditingController _addressController = TextEditingController();

  String? userInput;

  @override
  void initState() {
    super.initState();
    userInput = widget.userInput;
    if (userInput != null) {
      _addressController.text = userInput!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyGradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.title,
            style: const TextStyle(
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
              Navigator.pop(context, _addressController.text);
            },
            margin: EdgeInsets.all(1.35.h),
          ),
          leadingWidth: 14.8.w,
          actions: [
            Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 1.85.h),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, _addressController.text);
                },
                child: Container(
                  width: 14.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
                      style: TextStyle(color: kTitleBlack),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.7.h, vertical: 2.h),
                child: TextFormField(
                  controller: _addressController,
                  style: TextStyle(
                    fontSize: 11.5.sp,
                    color: const Color(0xFF1F1F39),
                  ),
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    //helperText: '',
                    filled: true,
                    fillColor: Colors.white,
                    hintText: widget.hintText,
                    hintStyle: TextStyle(
                      fontSize: 9.5.sp,
                      color: Colors.grey.shade400,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 1.8.h,
                      //vertical: 1.5.h,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kCardRadius),
                      borderSide: const BorderSide(
                        color: Color(0xFFF0F0F2),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.isNotEmpty && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 1.7.h, right: 1.7.h),
                  child: ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(
                          Icons.pin_drop,
                          color: kRegistrationSubtitleGrey,
                        ),
                        title: Text(
                          predictions[index].description!,
                          style: TextStyle(fontSize: 11.5.sp),
                        ),
                        onTap: () {
                          // debugPrint(predictions[index].placeId);
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => DetailsPage(
                          //       placeId: predictions[index].placeId,
                          //       googlePlace: googlePlace,
                          //     ),
                          //   ),
                          // );
                          setState(() {
                            _addressController.text =
                                predictions[index].description!;
                            _addressController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: _addressController.text.length));
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }
}
