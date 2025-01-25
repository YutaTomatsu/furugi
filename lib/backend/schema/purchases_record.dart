import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PurchasesRecord extends FirestoreRecord {
  PurchasesRecord._(
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

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "time_stamp" field.
  DateTime? _timeStamp;
  DateTime? get timeStamp => _timeStamp;
  bool hasTimeStamp() => _timeStamp != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _product = getDataList(snapshotData['product']);
    _price = castToType<int>(snapshotData['price']);
    _timeStamp = snapshotData['time_stamp'] as DateTime?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('purchases');

  static Stream<PurchasesRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => PurchasesRecord.fromSnapshot(s));

  static Future<PurchasesRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => PurchasesRecord.fromSnapshot(s));

  static PurchasesRecord fromSnapshot(DocumentSnapshot snapshot) =>
      PurchasesRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static PurchasesRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      PurchasesRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'PurchasesRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is PurchasesRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createPurchasesRecordData({
  DocumentReference? user,
  int? price,
  DateTime? timeStamp,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'price': price,
      'time_stamp': timeStamp,
    }.withoutNulls,
  );

  return firestoreData;
}

class PurchasesRecordDocumentEquality implements Equality<PurchasesRecord> {
  const PurchasesRecordDocumentEquality();

  @override
  bool equals(PurchasesRecord? e1, PurchasesRecord? e2) {
    const listEquality = ListEquality();
    return e1?.user == e2?.user &&
        listEquality.equals(e1?.product, e2?.product) &&
        e1?.price == e2?.price &&
        e1?.timeStamp == e2?.timeStamp;
  }

  @override
  int hash(PurchasesRecord? e) =>
      const ListEquality().hash([e?.user, e?.product, e?.price, e?.timeStamp]);

  @override
  bool isValidKey(Object? o) => o is PurchasesRecord;
}
