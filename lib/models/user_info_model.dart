//model for creating UserDetails objects
class UserDetails {
  String email;
  String firstName;
  String lastName;
  int dictLang;
  //constructor
  UserDetails(
      {required this.email,
      required this.firstName,
      required this.lastName,
      required this.dictLang});
}
