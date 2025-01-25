import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PaymentsRecord extends FirestoreRecord {
  PaymentsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "payment" field.
  String? _payment;
  String get payment => _payment ?? '';
  bool hasPayment() => _payment != null;

  // "sort_no" field.
  int? _sortNo;
  int get sortNo => _sortNo ?? 0;
  bool hasSortNo() => _sortNo != null;

  void _initializeFields() {
    _payment = snapshotData['payment'] as String?;
    _sortNo = castToType<int>(snapshotData['sort_no']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('payments');

  static Stream<PaymentsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PaymentsRecord.fromSnapshot(s));

  static Future<PaymentsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PaymentsRecord.fromSnapshot(s));

  static PaymentsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PaymentsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PaymentsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PaymentsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PaymentsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PaymentsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPaymentsRecordData({
  String? payment,
  int? sortNo,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'payment': payment,
      'sort_no': sortNo,
    }.withoutNulls,
  );

  return firestoreData;
}

class PaymentsRecordDocumentEquality implements Equality<PaymentsRecord> {
  const PaymentsRecordDocumentEquality();

  @override
  bool equals(PaymentsRecord? e1, PaymentsRecord? e2) {
    return e1?.payment == e2?.payment && e1?.sortNo == e2?.sortNo;
  }

  @override
  int hash(PaymentsRecord? e) =>
      const ListEquality().hash([e?.payment, e?.sortNo]);

  @override
  bool isValidKey(Object? o) => o is PaymentsRecord;
}
