import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetail {
  final String? age;
  final String? email;
  final bool? hasVotedForGov;
  final bool? hasVotedForPresd;
  final String? id;
  final String? name;
  final String? nin;
  final String? phoneNumber;
  final String? sex;
  final String? state;

  UserDetail(
      {required this.age,
      required this.email,
      required this.hasVotedForGov,
      required this.hasVotedForPresd,
      required this.id,
      required this.name,
      required this.nin,
      required this.phoneNumber,
        required this.sex,
      required this.state});

  factory UserDetail.getDoc(DocumentSnapshot doc) {
    return UserDetail(
        age: doc['age'],
        email: doc['email'],
        hasVotedForGov: doc['hasVotedForGov'],
        hasVotedForPresd: doc['hasVotedForPresd'],
        id: doc['id'],
        name: doc['name'],
        nin: doc['nin'],
        phoneNumber: doc['phoneNumber'],
        state: doc['state'],
        sex: doc['sex']
    );
  }

  toMap(UserDetail user) {
    Map map = {
      'id': user.id,
      'email': user.email,
      'age': user.age,
      'state': user.state,
      'phoneNumber': user.phoneNumber,
      'name': user.name,
      'nin': user.nin,
      'hasVotedForPresd': user.hasVotedForPresd,
      'hasVotedForGov': user.hasVotedForGov,
      'sex': user.sex
    };
  }
}
