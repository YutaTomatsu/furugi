import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class CartRecord extends FirestoreRecord {
  CartRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "time_stamp" field.
  DateTime? _timeStamp;
  DateTime? get timeStamp => _timeStamp;
  bool hasTimeStamp() => _timeStamp != null;

  // "product" field.
  List<DocumentReference>? _product;
  List<DocumentReference> get product => _product ?? const [];
  bool hasProduct() => _product != null;

  // "product_user" field.
  DocumentReference? _productUser;
  DocumentReference? get productUser => _productUser;
  bool hasProductUser() => _productUser != null;

  // "product_sum" field.
  int? _productSum;
  int get productSum => _productSum ?? 0;
  bool hasProductSum() => _productSum != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _timeStamp = snapshotData['time_stamp'] as DateTime?;
    _product = getDataList(snapshotData['product']);
    _productUser = snapshotData['product_user'] as DocumentReference?;
    _productSum = castToType<int>(snapshotData['product_sum']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('cart');

  static Stream<CartRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => CartRecord.fromSnapshot(s));

  static Future<CartRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => CartRecord.fromSnapshot(s));

  static CartRecord fromSnapshot(DocumentSnapshot snapshot) => CartRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static CartRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      CartRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'CartRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is CartRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createCartRecordData({
  DocumentReference? user,
  DateTime? timeStamp,
  DocumentReference? productUser,
  int? productSum,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'time_stamp': timeStamp,
      'product_user': productUser,
      'product_sum': productSum,
    }.withoutNulls,
  );

  return firestoreData;
}

class CartRecordDocumentEquality implements Equality<CartRecord> {
  const CartRecordDocumentEquality();

  @override
  bool equals(CartRecord? e1, CartRecord? e2) {
    const listEquality = ListEquality();
    return e1?.user == e2?.user &&
        e1?.timeStamp == e2?.timeStamp &&
        listEquality.equals(e1?.product, e2?.product) &&
        e1?.productUser == e2?.productUser &&
        e1?.productSum == e2?.productSum;
  }

  @override
  int hash(CartRecord? e) => const ListEquality()
      .hash([e?.user, e?.timeStamp, e?.product, e?.productUser, e?.productSum]);

  @override
  bool isValidKey(Object? o) => o is CartRecord;
}
