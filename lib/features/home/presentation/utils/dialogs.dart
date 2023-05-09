

import 'package:flutter/material.dart';

buildDialog(context,child){
  showDialog(context: context,
   builder:(context) {
     return Dialog(
      backgroundColor:Colors.white70,
      alignment: Alignment.center,
      elevation: 2,
      child: child,
     );
   }, 
  
  );
}