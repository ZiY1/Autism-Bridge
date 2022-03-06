class AsdUserCredentials {
  final String _userId;
  String _userEmail;
  bool _isFirstTimeIn;
  // String _userFirstName;
  // String _userLastName;

  AsdUserCredentials({
    required String userId,
    required String userEmail,
    required bool isFirstTimeIn,
    // required String userFirstName,
    // required String userLastName,
  })  : _userId = userId,
        _userEmail = userEmail,
        _isFirstTimeIn = isFirstTimeIn;
  // _userFirstName = userFirstName,
  // _userLastName = userLastName;

  // getters
  String get userId => _userId;

  String get userEmail => _userEmail;

  bool get isFirstTimeIn => _isFirstTimeIn;

  // String get userFirstName => _userFirstName;
  //
  // String get userLastName => _userLastName;

  // setters
  set setUserEmail(String email) => _userEmail = email;

  set setIsFirstTimeIn(bool isFirstTimeIn) => _isFirstTimeIn = isFirstTimeIn;

  // set setUserFirstName(String firstName) => _userFirstName = firstName;
  //
  // set setUserLastName(String lastName) => _userLastName = lastName;
}
