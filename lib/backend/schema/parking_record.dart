import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ParkingRecord extends FirestoreRecord {
  ParkingRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "sort_no" field.
  int? _sortNo;
  int get sortNo => _sortNo ?? 0;
  bool hasSortNo() => _sortNo != null;

  // "exist" field.
  String? _exist;
  String get exist => _exist ?? '';
  bool hasexist() => _exist != null;

  void _initializeFields() {
    _sortNo = castToType<int>(snapshotData['sort_no']);
    _exist = snapshotData['exist'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('parking');

  static Stream<ParkingRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ParkingRecord.fromSnapshot(s));

  static Future<ParkingRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ParkingRecord.fromSnapshot(s));

  static ParkingRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ParkingRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ParkingRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ParkingRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ParkingRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ParkingRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createParkingRecordData({
  int? sortNo,
  String? exist,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sort_no': sortNo,
      'exist': exist,
    }.withoutNulls,
  );

  return firestoreData;
}

class ParkingRecordDocumentEquality implements Equality<ParkingRecord> {
  const ParkingRecordDocumentEquality();

  @override
  bool equals(ParkingRecord? e1, ParkingRecord? e2) {
    return e1?.sortNo == e2?.sortNo && e1?.exist == e2?.exist;
  }

  @override
  int hash(ParkingRecord? e) =>
      const ListEquality().hash([e?.sortNo, e?.exist]);

  @override
  bool isValidKey(Object? o) => o is ParkingRecord;
}
