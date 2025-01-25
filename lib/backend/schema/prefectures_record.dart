import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PrefecturesRecord extends FirestoreRecord {
  PrefecturesRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "prefecture" field.
  String? _prefecture;
  String get prefecture => _prefecture ?? '';
  bool hasPrefecture() => _prefecture != null;

  // "sort_no" field.
  int? _sortNo;
  int get sortNo => _sortNo ?? 0;
  bool hasSortNo() => _sortNo != null;

  void _initializeFields() {
    _prefecture = snapshotData['prefecture'] as String?;
    _sortNo = castToType<int>(snapshotData['sort_no']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('prefectures');

  static Stream<PrefecturesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PrefecturesRecord.fromSnapshot(s));

  static Future<PrefecturesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PrefecturesRecord.fromSnapshot(s));

  static PrefecturesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PrefecturesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PrefecturesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PrefecturesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PrefecturesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PrefecturesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPrefecturesRecordData({
  String? prefecture,
  int? sortNo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'prefecture': prefecture,
      'sort_no': sortNo,
    }.withoutNulls,
  );

  return firestoreData;
}

class PrefecturesRecordDocumentEquality implements Equality<PrefecturesRecord> {
  const PrefecturesRecordDocumentEquality();

  @override
  bool equals(PrefecturesRecord? e1, PrefecturesRecord? e2) {
    return e1?.prefecture == e2?.prefecture && e1?.sortNo == e2?.sortNo;
  }

  @override
  int hash(PrefecturesRecord? e) =>
      const ListEquality().hash([e?.prefecture, e?.sortNo]);

  @override
  bool isValidKey(Object? o) => o is PrefecturesRecord;
}
