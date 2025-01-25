import 'dart:async';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';
import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProductsRecord extends FirestoreRecord {
  ProductsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "name" field.
  String? _name;
  String get name => _name ?? '';
  bool hasName() => _name != null;

  // "detail" field.
  String? _detail;
  String get detail => _detail ?? '';
  bool hasDetail() => _detail != null;

  // "condition" field.
  String? _condition;
  String get condition => _condition ?? '';
  bool hasCondition() => _condition != null;

  // "created_time" field.
  DateTime? _createdTime;
  DateTime? get createdTime => _createdTime;
  bool hasCreatedTime() => _createdTime != null;

  // "like" field.
  List<DocumentReference>? _like;
  List<DocumentReference> get like => _like ?? const [];
  bool hasLike() => _like != null;

  // "category" field.
  List<String>? _category;
  List<String> get category => _category ?? const [];
  bool hasCategory() => _category != null;

  // "cart" field.
  List<DocumentReference>? _cart;
  List<DocumentReference> get cart => _cart ?? const [];
  bool hasCart() => _cart != null;

  // "price" field.
  int? _price;
  int get price => _price ?? 0;
  bool hasPrice() => _price != null;

  // "sold" field.
  bool? _sold;
  bool get sold => _sold ?? false;
  bool hasSold() => _sold != null;

  // "images" field.
  List<String>? _images;
  List<String> get images => _images ?? const [];
  bool hasImages() => _images != null;

  // "shipping_days" field.
  String? _shippingDays;
  String get shippingDays => _shippingDays ?? '';
  bool hasShippingDays() => _shippingDays != null;

  // "shipping_cost" field.
  String? _shippingCost;
  String get shippingCost => _shippingCost ?? '';
  bool hasShippingCost() => _shippingCost != null;

  // "size" field.
  String? _size;
  String get size => _size ?? '';
  bool hasSize() => _size != null;

  // "prefecture" field.
  String? _prefecture;
  String get prefecture => _prefecture ?? '';
  bool hasPrefecture() => _prefecture != null;

  DocumentReference get parentReference => reference.parent.parent!;

  void _initializeFields() {
    _name = snapshotData['name'] as String?;
    _detail = snapshotData['detail'] as String?;
    _condition = snapshotData['condition'] as String?;

    _createdTime = snapshotData['created_time'] is Timestamp
        ? (snapshotData['created_time'] as Timestamp).toDate()
        : null;

    _like = getDataList(snapshotData['like']);
    _category = getDataList(snapshotData['category']);
    _cart = getDataList(snapshotData['cart']);
    _price = castToType<int>(snapshotData['price']);
    _sold = snapshotData['sold'] as bool?;
    _images = getDataList(snapshotData['images']);
    _shippingDays = snapshotData['shipping_days'] as String?;
    _shippingCost = snapshotData['shipping_cost'] as String?;
    _size = snapshotData['size'] as String?;
    _prefecture = snapshotData['prefecture'] as String?;
  }

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('products')
          : FirebaseFirestore.instance.collectionGroup('products');

  static DocumentReference createDoc(DocumentReference parent, {String? id}) =>
      parent.collection('products').doc(id);

  static Stream<ProductsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ProductsRecord.fromSnapshot(s));

  static Future<ProductsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ProductsRecord.fromSnapshot(s));

  static ProductsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ProductsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ProductsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ProductsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ProductsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ProductsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createProductsRecordData({
  String? name,
  String? detail,
  String? condition,
  DateTime? createdTime,
  int? price,
  bool? sold,
  List<String>? images,
  String? shippingDays,
  String? shippingCost,
  String? size,
  String? prefecture,
  String? category,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'detail': detail,
      'condition': condition,
      'created_time': createdTime,
      'price': price,
      'sold': sold,
      'images': images,
      'shipping_days': shippingDays,
      'shipping_cost': shippingCost,
      'size': size,
      'prefecture': prefecture,
      'category': category,
    }.withoutNulls,
  );

  return firestoreData;
}

class ProductsRecordDocumentEquality implements Equality<ProductsRecord> {
  const ProductsRecordDocumentEquality();

  @override
  bool equals(ProductsRecord? e1, ProductsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.name == e2?.name &&
        e1?.detail == e2?.detail &&
        e1?.condition == e2?.condition &&
        e1?.createdTime == e2?.createdTime &&
        listEquality.equals(e1?.like, e2?.like) &&
        e1?.category == e2?.category &&
        listEquality.equals(e1?.cart, e2?.cart) &&
        e1?.price == e2?.price &&
        e1?.sold == e2?.sold &&
        listEquality.equals(e1?.images, e2?.images) &&
        e1?.shippingDays == e2?.shippingDays &&
        e1?.shippingCost == e2?.shippingCost &&
        e1?.size == e2?.size &&
        e1?.prefecture == e2?.prefecture;
  }

  @override
  int hash(ProductsRecord? e) => const ListEquality().hash([
        e?.name,
        e?.detail,
        e?.condition,
        e?.createdTime,
        e?.like,
        e?.category,
        e?.cart,
        e?.price,
        e?.sold,
        e?.images,
        e?.shippingDays,
        e?.shippingCost,
        e?.size,
        e?.prefecture,
      ]);

  @override
  bool isValidKey(Object? o) => o is ProductsRecord;
}
