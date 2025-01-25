import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class GendersRecord extends FirestoreRecord {
  GendersRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "sort_no" field.
  int? _sortNo;
  int get sortNo => _sortNo ?? 0;
  bool hasSortNo() => _sortNo != null;

  // "gender" field.
  String? _gender;
  String get gender => _gender ?? '';
  bool hasDay() => _gender != null;

  void _initializeFields() {
    _sortNo = castToType<int>(snapshotData['sort_no']);
    _gender = snapshotData['gender'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('genders');

  static Stream<GendersRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => GendersRecord.fromSnapshot(s));

  static Future<GendersRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => GendersRecord.fromSnapshot(s));

  static GendersRecord fromSnapshot(DocumentSnapshot snapshot) =>
      GendersRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static GendersRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      GendersRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'GendersRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is GendersRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createGendersRecordData({int? sortNo, String? gender}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sort_no': sortNo,
      'gender': gender,
    }.withoutNulls,
  );

  return firestoreData;
}

class GendersRecordDocumentEquality implements Equality<GendersRecord> {
  const GendersRecordDocumentEquality();

  @override
  bool equals(GendersRecord? e1, GendersRecord? e2) {
    return e1?.sortNo == e2?.sortNo && e1?.gender == e2?.gender;
  }

  @override
  int hash(GendersRecord? e) =>
      const ListEquality().hash([e?.sortNo, e?.gender]);

  @override
  bool isValidKey(Object? o) => o is GendersRecord;
}
