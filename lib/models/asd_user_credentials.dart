class AsdUserCredentials {
  final String _userId;
  String _userEmail;
  String _userFirstName;
  String _userLastName;

  AsdUserCredentials({
    required String userId,
    required String userEmail,
    required String userFirstName,
    required String userLastName,
  })  : _userId = userId,
        _userEmail = userEmail,
        _userFirstName = userFirstName,
        _userLastName = userLastName;

  // getters
  String get userId => _userId;

  String get userEmail => _userEmail;

  String get userFirstName => _userFirstName;

  String get userLastName => _userLastName;

  // setters
  set setUserEmail(String email) => _userEmail = email;

  set setUserFirstName(String firstName) => _userFirstName = firstName;

  set setUserLastName(String lastName) => _userLastName = lastName;
}
