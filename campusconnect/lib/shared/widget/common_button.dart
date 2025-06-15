import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';
class CommonButton extends StatelessWidget{

  final VoidCallback onPressed;
  final String text;
  final double borderRadius;
  final Color bgColor;
  final Color textColor;
  final double textSize;
  final double height;
  final double width;

  const CommonButton({
    required this.onPressed,required this.text,this.borderRadius=10,this.bgColor=   const Color(0xff072A6C),this.textColor=const Color(0xFFFFFFFF),this.textSize=16,this.height=35,this.width=100,
    super.key});




  @override
  Widget build(BuildContext context) {

    return GestureDetector(
        onTap:onPressed ,
        child:Padding( padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),child:Container(
          width: width,
          height: height,
          alignment: Alignment.center,

          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius), // Add rounded corners to the button container
            color: bgColor, // Background color of the button
          ),
          child: ElevatedButton(

            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent, // Make button background transparent
              elevation: 0, // Remove button shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Add rounded corners to the button
              ),
            ),
            child: Text(
              text,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(

                fontSize: textSize,
                fontFamily: 'Poppins',
                color: textColor, // Text color
              ),
            ),
          ),
        )));
  }
}