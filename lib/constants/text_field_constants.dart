import 'package:chat_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

const kTextInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: AppColors.indyBlue,
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.indyBlue,
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
   focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.indyBlue,
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
   errorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.red,
      width: 1.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
);
