import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PurchasedConversationsRecord extends FirestoreRecord {
  PurchasedConversationsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "product" field.
  List<DocumentReference>? _product;
  List<DocumentReference> get product => _product ?? const [];
  bool hasProduct() => _product != null;

  // "comment" field.
  String? _comment;
  String get comment => _comment ?? '';
  bool hasComment() => _comment != null;

  // "time_stump" field.
  DateTime? _timeStump;
  DateTime? get timeStump => _timeStump;
  bool hasTimeStump() => _timeStump != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _product = getDataList(snapshotData['product']);
    _comment = snapshotData['comment'] as String?;
    _timeStump = snapshotData['time_stump'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('purchased_conversations');

  static Stream<PurchasedConversationsRecord> getDocument(
          DocumentReference ref) =>
      ref.snapshots().map((s) => PurchasedConversationsRecord.fromSnapshot(s));

  static Future<PurchasedConversationsRecord> getDocumentOnce(
          DocumentReference ref) =>
      ref.get().then((s) => PurchasedConversationsRecord.fromSnapshot(s));

  static PurchasedConversationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PurchasedConversationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PurchasedConversationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PurchasedConversationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PurchasedConversationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PurchasedConversationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPurchasedConversationsRecordData({
  DocumentReference? user,
  String? comment,
  DateTime? timeStump,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'comment': comment,
      'time_stump': timeStump,
    }.withoutNulls,
  );

  return firestoreData;
}

class PurchasedConversationsRecordDocumentEquality
    implements Equality<PurchasedConversationsRecord> {
  const PurchasedConversationsRecordDocumentEquality();

  @override
  bool equals(
      PurchasedConversationsRecord? e1, PurchasedConversationsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.user == e2?.user &&
        listEquality.equals(e1?.product, e2?.product) &&
        e1?.comment == e2?.comment &&
        e1?.timeStump == e2?.timeStump;
  }

  @override
  int hash(PurchasedConversationsRecord? e) => const ListEquality()
      .hash([e?.user, e?.product, e?.comment, e?.timeStump]);

  @override
  bool isValidKey(Object? o) => o is PurchasedConversationsRecord;
}
