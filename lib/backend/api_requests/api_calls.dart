import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class ZipcodeAPICall {
  static Future<ApiCallResponse> call({
    String? zipcode = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'zipcode API',
      apiUrl: 'https://zipcloud.ibsnet.co.jp/api/search',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'zipcode': zipcode,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GoogleGeocodingAPICall {
  static Future<ApiCallResponse> call({
    String? address = '愛知県春日井市鳥居松町７丁目６１番地',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Google Geocoding API',
      apiUrl: 'https://maps.googleapis.com/maps/api/geocode/json',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'address': address,
        'key': "AIzaSyDcmGm7KkqS3OTaVlO0ZlWnNQ2qLC_ads0",
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic latitude(dynamic response) => getJsonField(
        response,
        r'''$.results[0].geometry.location.lat''',
      );
  static dynamic longitude(dynamic response) => getJsonField(
        response,
        r'''$.results[0].geometry.location.lng''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
