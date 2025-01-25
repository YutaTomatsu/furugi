import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ConditionsRecord extends FirestoreRecord {
  ConditionsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  bool hasCondition() => _condition != null;

  // "sort_no" field.
  int? _sortNo;
  int get sortNo => _sortNo ?? 0;
  bool hasSortNo() => _sortNo != null;

  void _initializeFields() {
    _condition = snapshotData['condition'] as String?;
    _sortNo = castToType<int>(snapshotData['sort_no']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('conditions');

  static Stream<ConditionsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ConditionsRecord.fromSnapshot(s));

  static Future<ConditionsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ConditionsRecord.fromSnapshot(s));

  static ConditionsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ConditionsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ConditionsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ConditionsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ConditionsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ConditionsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createConditionsRecordData({
  String? condition,
  int? sortNo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'condition': condition,
      'sort_no': sortNo,
    }.withoutNulls,
  );

  return firestoreData;
}

class ConditionsRecordDocumentEquality implements Equality<ConditionsRecord> {
  const ConditionsRecordDocumentEquality();

  @override
  bool equals(ConditionsRecord? e1, ConditionsRecord? e2) {
    return e1?.condition == e2?.condition && e1?.sortNo == e2?.sortNo;
  }

  @override
  int hash(ConditionsRecord? e) =>
      const ListEquality().hash([e?.condition, e?.sortNo]);

  @override
  bool isValidKey(Object? o) => o is ConditionsRecord;
}
