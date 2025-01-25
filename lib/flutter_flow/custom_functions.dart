import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

LatLng formatLatLng(
  double lat,
  double lng,
) {
  return LatLng(lat, lng);
}

bool searchTextField(
  String? text,
  String? search,
) {
  // Determine if the string "text" contains the string "search"
  if (text == null || search == null) {
    return false;
  }
  return text.toLowerCase().contains(search.toLowerCase());
}

int? newCustomFunction(int? num1) {
  // Multiply the input value by -1 and return it.
  if (num1 == null) {
    return null;
  }
  return num1 * -1;
}

double? ratingAvarage(List<double>? reviews) {
  // I want to calculate the average value of evaluation based on the data in the evaluation column of the reviews table.
  if (reviews == null || reviews.isEmpty) {
    return null;
  }

  double sum = 0;
  for (double review in reviews) {
    sum += review;
  }

  return sum / reviews.length;
}
