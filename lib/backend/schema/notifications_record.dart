import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';
import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class NotificationsRecord extends FirestoreRecord {
  NotificationsRecord._(
    super.reference,
    super.data,
  ) {
    _initializeFields();
  }

  // "user" field.
  DocumentReference? _user;
  DocumentReference? get user => _user;
  bool hasUser() => _user != null;

  // "detail" field.
  String? _detail;
  String get detail => _detail ?? '';
  bool hasDetail() => _detail != null;

  // "time_stamp" field.
  DateTime? _timeStamp;
  DateTime? get timeStamp => _timeStamp;
  bool hasTimeStamp() => _timeStamp != null;

  // "product" field.
  List<DocumentReference>? _product;
  List<DocumentReference> get product => _product ?? const [];
  bool hasProduct() => _product != null;

  // "about" field.
  String? _about;
  String get about => _about ?? '';
  bool hasAbout() => _about != null;

  void _initializeFields() {
    _user = snapshotData['user'] as DocumentReference?;
    _detail = snapshotData['detail'] as String?;
    _timeStamp = snapshotData['time_stamp'] as DateTime?;
    _product = getDataList(snapshotData['product']);
    _about = snapshotData['about'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('notifications');

  static Stream<NotificationsRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => NotificationsRecord.fromSnapshot(s));

  static Future<NotificationsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => NotificationsRecord.fromSnapshot(s));

  static NotificationsRecord fromSnapshot(DocumentSnapshot snapshot) =>
      NotificationsRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static NotificationsRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      NotificationsRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'NotificationsRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is NotificationsRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createNotificationsRecordData({
  DocumentReference? user,
  String? detail,
  DateTime? timeStamp,
  String? about,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user': user,
      'detail': detail,
      'time_stamp': timeStamp,
      'about': about,
    }.withoutNulls,
  );

  return firestoreData;
}

class NotificationsRecordDocumentEquality
    implements Equality<NotificationsRecord> {
  const NotificationsRecordDocumentEquality();

  @override
  bool equals(NotificationsRecord? e1, NotificationsRecord? e2) {
    const listEquality = ListEquality();
    return e1?.user == e2?.user &&
        e1?.detail == e2?.detail &&
        e1?.timeStamp == e2?.timeStamp &&
        listEquality.equals(e1?.product, e2?.product) &&
        e1?.about == e2?.about;
  }

  @override
  int hash(NotificationsRecord? e) => const ListEquality()
      .hash([e?.user, e?.detail, e?.timeStamp, e?.product, e?.about]);

  @override
  bool isValidKey(Object? o) => o is NotificationsRecord;
}
