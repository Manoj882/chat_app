

import 'package:chat_app/constants/color_constants.dart';
import 'package:flutter/material.dart';

Widget messageBubble(
    {required String chatContent,
    required EdgeInsetsGeometry? margin,
    Color? color,
    Color? textColor}) {
  return Container(
    padding: const EdgeInsets.all(10),
    margin: margin,
    width: 200,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      chatContent,
      style: TextStyle(fontSize: 16, color: textColor),
    ),
  );
}

Widget errorContainer(){
  return Container(
    clipBehavior: Clip.hardEdge,
    child: Image.asset(
      'assets/images/img_not_available.jpeg'
    ),
  );
}

Widget chatImage({required String imageSrc, required Function onTap}) {
  return OutlinedButton(
    onPressed: onTap(),
    child: Image.network(
      imageSrc,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if(loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.greyColor2,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 200,
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.burgundy,
              value: loadingProgress.expectedTotalBytes != null && loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
              : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => errorContainer(),
    ),
  );
}
