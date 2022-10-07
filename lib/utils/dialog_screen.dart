import 'dart:io';


import 'package:flutter/material.dart';

class DialogScreens {
  Future<void> openDialog(BuildContext context) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            backgroundColor: Colors.blue,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exit Application',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Are you sure?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 0);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: (){
                      Navigator.pop(context,1);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(14, 8, 14, 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Yes',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        })) {
          case 0:
            break;
          case 1:
            exit(0);

          
    }
  }
}
