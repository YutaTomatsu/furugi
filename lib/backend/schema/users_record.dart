import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class UsersRecord extends FirestoreRecord {
  UsersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "display_name" field.
  String? _displayName;
  String get displayName => _displayName ?? '';
  bool hasDisplayName() => _displayName != null;

  // "uid" field.
  String? _uid;
  String get uid => _uid ?? '';
  bool hasUid() => _uid != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "phone_number" field.
  String? _phoneNumber;
  String get phoneNumber => _phoneNumber ?? '';
  bool hasPhoneNumber() => _phoneNumber != null;

  // "gender" field.
  bool? _gender;
  bool get gender => _gender ?? false;
  bool hasGender() => _gender != null;

// "Address" field を List 型に変更（各住所は Map 型）
  List<dynamic>? _address;
  List<Map<String, dynamic>> get address =>
      _address?.map((e) => e as Map<String, dynamic>).toList() ?? [];
  bool hasAddress() => _address != null;

// default_shipping_address のインデックス（既定の配送先）
  int? _defaultAddressIndex;
  int get defaultAddressIndex => _defaultAddressIndex ?? 0;
  bool hasDefaultAddressIndex() => _defaultAddressIndex != null;

  // "image" field.
  String? _image;
  String get image => _image ?? '';
  bool hasImage() => _image != null;

  // "product" field.
  List<DocumentReference>? _product;
  List<DocumentReference> get product => _product ?? const [];
  bool hasProduct() => _product != null;

  // "following_user" field.
  List<DocumentReference>? _followingUser;
  List<DocumentReference> get followingUser => _followingUser ?? const [];
  bool hasFollowingUser() => _followingUser != null;

  // "followed_user" field.
  List<DocumentReference>? _followedUser;
  List<DocumentReference> get followedUser => _followedUser ?? const [];
  bool hasFollowedUser() => _followedUser != null;

  // "photo_url" field.
  String? _photoUrl;
  String get photoUrl => _photoUrl ?? '';
  bool hasPhotoUrl() => _photoUrl != null;

  // default_shipping_address のインデックス（既定の配送先）
  int? _postalCode;
  int get postalCode => _postalCode ?? 0;
  bool hasPostalCode() => _postalCode != null;

  void _initializeFields() {
    _email = snapshotData['email'] as String?;
    _displayName = snapshotData['display_name'] as String?;
    _uid = snapshotData['uid'] as String?;
    _createdTime = snapshotData['created_time'] as DateTime?;
    _phoneNumber = snapshotData['phone_number'] as String?;
    _gender = snapshotData['gender'] as bool?;
    _address = snapshotData['Address'] as List<dynamic>?;
    _defaultAddressIndex = snapshotData['default_address_index'] as int?;
    _image = snapshotData['image'] as String?;
    _product = getDataList(snapshotData['product']);
    _followingUser = getDataList(snapshotData['following_user']);
    _followedUser = getDataList(snapshotData['followed_user']);
    _photoUrl = snapshotData['photo_url'] as String?;
    _postalCode = snapshotData['postal_code'] as int?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('Users');

  static Stream<UsersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => UsersRecord.fromSnapshot(s));

  static Future<UsersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => UsersRecord.fromSnapshot(s));

  static UsersRecord fromSnapshot(DocumentSnapshot snapshot) => UsersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static UsersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      UsersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'UsersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is UsersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createUsersRecordData({
  String? email,
  String? displayName,
  String? uid,
  DateTime? createdTime,
  String? phoneNumber,
  bool? gender,
  List<Map<String, dynamic>>? address,
  int? defaultAddressIndex,
  String? image,
  String? photoUrl,
  int? postalCode,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'email': email,
      'display_name': displayName,
      'uid': uid,
      'created_time': createdTime,
      'phone_number': phoneNumber,
      'gender': gender,
      'Address': address,
      'default_address_index': defaultAddressIndex,
      'image': image,
      'photo_url': photoUrl,
      'postal_code': postalCode,
    }.withoutNulls,
  );
  return firestoreData;
}

class UsersRecordDocumentEquality implements Equality<UsersRecord> {
  const UsersRecordDocumentEquality();

  @override
  bool equals(UsersRecord? e1, UsersRecord? e2) {
    const listEquality = ListEquality();
    return e1?.email == e2?.email &&
        e1?.displayName == e2?.displayName &&
        e1?.uid == e2?.uid &&
        e1?.createdTime == e2?.createdTime &&
        e1?.phoneNumber == e2?.phoneNumber &&
        e1?.gender == e2?.gender &&
        e1?.address == e2?.address &&
        e1?.image == e2?.image &&
        e1?.postalCode == e2?.postalCode &&
        listEquality.equals(e1?.product, e2?.product) &&
        listEquality.equals(e1?.followingUser, e2?.followingUser) &&
        listEquality.equals(e1?.followedUser, e2?.followedUser) &&
        e1?.photoUrl == e2?.photoUrl;
  }

  @override
  int hash(UsersRecord? e) => const ListEquality().hash([
        e?.email,
        e?.displayName,
        e?.uid,
        e?.createdTime,
        e?.phoneNumber,
        e?.gender,
        e?.address,
        e?.image,
        e?.product,
        e?.followingUser,
        e?.followedUser,
        e?.photoUrl,
        e?.postalCode
      ]);

  @override
  bool isValidKey(Object? o) => o is UsersRecord;
}
