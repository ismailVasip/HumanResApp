import 'package:flutter/material.dart';

  Color getColor(String name) {
  switch (name) {
    case 'pending':
      return Colors.orange;
    case 'autoApproved':
    case 'manualApproved':
      return Colors.green;
    case 'rejected':
      return Colors.red;
    default:
      return Colors.amber;
  }
}
