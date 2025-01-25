import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ReviewsRecord extends FirestoreRecord {
  ReviewsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "product_user" field.
  DocumentReference? _productUser;
  DocumentReference? get productUser => _productUser;
  bool hasProductUser() => _productUser != null;

  // "product" field.
  List<DocumentReference>? _product;
  List<DocumentReference> get product => _product ?? const [];
  bool hasProduct() => _product != null;

  // "review" field.
  String? _review;
  String get review => _review ?? '';
  bool hasReview() => _review != null;

  // "time_stamp" field.
  DateTime? _timeStamp;
  DateTime? get timeStamp => _timeStamp;
  bool hasTimeStamp() => _timeStamp != null;

  // "evaluation" field.
  double? _evaluation;
  double get evaluation => _evaluation ?? 0.0;
  bool hasEvaluation() => _evaluation != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _productUser = snapshotData['product_user'] as DocumentReference?;
    _product = getDataList(snapshotData['product']);
    _review = snapshotData['review'] as String?;
    _timeStamp = snapshotData['time_stamp'] as DateTime?;
    _evaluation = castToType<double>(snapshotData['evaluation']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('reviews');

  static Stream<ReviewsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ReviewsRecord.fromSnapshot(s));

  static Future<ReviewsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ReviewsRecord.fromSnapshot(s));

  static ReviewsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ReviewsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ReviewsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ReviewsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ReviewsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ReviewsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createReviewsRecordData({
  DocumentReference? user,
  DocumentReference? productUser,
  String? review,
  DateTime? timeStamp,
  double? evaluation,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'product_user': productUser,
      'review': review,
      'time_stamp': timeStamp,
      'evaluation': evaluation,
    }.withoutNulls,
  );

  return firestoreData;
}

class ReviewsRecordDocumentEquality implements Equality<ReviewsRecord> {
  const ReviewsRecordDocumentEquality();

  @override
  bool equals(ReviewsRecord? e1, ReviewsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.user == e2?.user &&
        e1?.productUser == e2?.productUser &&
        listEquality.equals(e1?.product, e2?.product) &&
        e1?.review == e2?.review &&
        e1?.timeStamp == e2?.timeStamp &&
        e1?.evaluation == e2?.evaluation;
  }

  @override
  int hash(ReviewsRecord? e) => const ListEquality().hash([
        e?.user,
        e?.productUser,
        e?.product,
        e?.review,
        e?.timeStamp,
        e?.evaluation
      ]);

  @override
  bool isValidKey(Object? o) => o is ReviewsRecord;
}
