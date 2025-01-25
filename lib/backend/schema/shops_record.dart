import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ShopsRecord extends FirestoreRecord {
  ShopsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "address" field.
  String? _address;
  String get address => _address ?? '';
  bool hasAddress() => _address != null;

  // "prefecture" field.
  String? _prefecture;
  String get prefecture => _prefecture ?? '';
  bool hasPrefecture() => _prefecture != null;

  // "post" field.
  String? _post;
  String get post => _post ?? '';
  bool hasPost() => _post != null;

  // "features" field.
  String? _features;
  String get features => _features ?? '';
  bool hasFeatures() => _features != null;

  // "payment" field.
  List<String>? _payment;
  List<String> get payment => _payment ?? const [];
  bool hasPayment() => _payment != null;

  // "price_range" field.
  String? _priceRange;
  String get priceRange => _priceRange ?? '';
  bool hasPriceRange() => _priceRange != null;

  // "hp" field.
  String? _hp;
  String get hp => _hp ?? '';
  bool hasHp() => _hp != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "like" field.
  List<DocumentReference>? _like;
  List<DocumentReference> get like => _like ?? const [];
  bool hasLike() => _like != null;

  // "closed_day" field.
  List<String>? _closedDay;
  List<String> get closedDay => _closedDay ?? const [];
  bool hasClosedDay() => _closedDay != null;

  // "genders" field.
  List<String>? _genders;
  List<String> get genders => _genders ?? const [];
  bool hasGenders() => _genders != null;

  // "parking" field.
  List<String>? _parking;
  List<String> get parking => _parking ?? const [];
  bool hasParking() => _parking != null;

  // "location" field.
  LatLng? _location;
  LatLng? get location => _location;
  bool hasLocation() => _location != null;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _address = snapshotData['address'] as String?;
    _prefecture = snapshotData['prefecture'] as String?;
    _post = snapshotData['post'] as String?;
    _features = snapshotData['features'] as String?;
    _payment = getDataList(snapshotData['payment']);
    _priceRange = snapshotData['price_range'] as String?;
    _hp = snapshotData['hp'] as String?;
    _images = getDataList(snapshotData['images']);
    _createdTime = snapshotData['created_time'] as DateTime?;
    _like = getDataList(snapshotData['like']);
    _closedDay = getDataList(snapshotData['closed_day']);
    _genders = getDataList(snapshotData['genders']);
    _parking = getDataList(snapshotData['parking']);
    _location = snapshotData['location'] as LatLng?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('shops');

  static Stream<ShopsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ShopsRecord.fromSnapshot(s));

  static Future<ShopsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ShopsRecord.fromSnapshot(s));

  static ShopsRecord fromSnapshot(DocumentSnapshot snapshot) => ShopsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ShopsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ShopsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ShopsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ShopsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createShopsRecordData({
  String? name,
  String? address,
  String? prefecture,
  String? post,
  String? features,
  String? priceRange,
  String? hp,
  List<String>? images,
  DateTime? createdTime,
  LatLng? location,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'address': address,
      'prefecture': prefecture,
      'post': post,
      'features': features,
      'price_range': priceRange,
      'hp': hp,
      'images': images,
      'created_time': createdTime,
      'location': location,
    }.withoutNulls,
  );

  return firestoreData;
}

class ShopsRecordDocumentEquality implements Equality<ShopsRecord> {
  const ShopsRecordDocumentEquality();

  @override
  bool equals(ShopsRecord? e1, ShopsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.address == e2?.address &&
        e1?.prefecture == e2?.prefecture &&
        e1?.post == e2?.post &&
        e1?.features == e2?.features &&
        listEquality.equals(e1?.payment, e2?.payment) &&
        e1?.priceRange == e2?.priceRange &&
        e1?.hp == e2?.hp &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.createdTime == e2?.createdTime &&
        listEquality.equals(e1?.like, e2?.like) &&
        listEquality.equals(e1?.closedDay, e2?.closedDay) &&
        listEquality.equals(e1?.genders, e2?.genders) &&
        listEquality.equals(e1?.parking, e2?.parking) &&
        e1?.location == e2?.location;
  }

  @override
  int hash(ShopsRecord? e) => const ListEquality().hash([
        e?.name,
        e?.address,
        e?.prefecture,
        e?.post,
        e?.features,
        e?.payment,
        e?.priceRange,
        e?.hp,
        e?.images,
        e?.createdTime,
        e?.like,
        e?.closedDay,
        e?.genders,
        e?.parking,
        e?.location
      ]);

  @override
  bool isValidKey(Object? o) => o is ShopsRecord;
}
