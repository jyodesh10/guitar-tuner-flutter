

import 'package:flutter/material.dart';

buildDialog(context,child){
  showDialog(context: context,
   builder:(context) {
     return Dialog(
      alignment: Alignment.center,
      child: child,
     );
   }, 
  
  );
}