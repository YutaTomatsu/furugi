import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ClosedDaysRecord extends FirestoreRecord {
  ClosedDaysRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "sort_no" field.
  int? _sortNo;
  int get sortNo => _sortNo ?? 0;
  bool hasSortNo() => _sortNo != null;

  // "day" field.
  String? _day;
  String get day => _day ?? '';
  bool hasDay() => _day != null;

  void _initializeFields() {
    _sortNo = castToType<int>(snapshotData['sort_no']);
    _day = snapshotData['day'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('closed_days');

  static Stream<ClosedDaysRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ClosedDaysRecord.fromSnapshot(s));

  static Future<ClosedDaysRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ClosedDaysRecord.fromSnapshot(s));

  static ClosedDaysRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ClosedDaysRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ClosedDaysRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ClosedDaysRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ClosedDaysRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ClosedDaysRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createClosedDaysRecordData({
  int? sortNo,
  String? day,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'sort_no': sortNo,
      'day': day,
    }.withoutNulls,
  );

  return firestoreData;
}

class ClosedDaysRecordDocumentEquality implements Equality<ClosedDaysRecord> {
  const ClosedDaysRecordDocumentEquality();

  @override
  bool equals(ClosedDaysRecord? e1, ClosedDaysRecord? e2) {
    return e1?.sortNo == e2?.sortNo && e1?.day == e2?.day;
  }

  @override
  int hash(ClosedDaysRecord? e) =>
      const ListEquality().hash([e?.sortNo, e?.day]);

  @override
  bool isValidKey(Object? o) => o is ClosedDaysRecord;
}
