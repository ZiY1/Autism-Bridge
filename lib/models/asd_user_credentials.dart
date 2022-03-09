class AsdUserCredentials {
  final String _userId;
  String _userEmail;
  bool _isFirstTimeIn;

  AsdUserCredentials({
    required String userId,
    required String userEmail,
    required bool isFirstTimeIn,
  })  : _userId = userId,
        _userEmail = userEmail,
        _isFirstTimeIn = isFirstTimeIn;

  // getters
  String get userId => _userId;

  String get userEmail => _userEmail;

  bool get isFirstTimeIn => _isFirstTimeIn;

  // setters
  set setUserEmail(String email) => _userEmail = email;

  set setIsFirstTimeIn(bool isFirstTimeIn) => _isFirstTimeIn = isFirstTimeIn;
}
