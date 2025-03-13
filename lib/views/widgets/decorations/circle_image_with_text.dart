import 'package:flutter/material.dart';

class CircleImageWithText extends StatelessWidget{
  final String label;
  final String? imagePath;
  final String? imageUrl;
  final double verticalPadding;
  final double horizontalPadding;
  final bool isSelected;

  const CircleImageWithText({
    super.key,
    required this.label,
    this.imagePath,
    this.imageUrl,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.isSelected = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding,),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundImage: (imagePath != null ? AssetImage(imagePath!) :
            imageUrl != null ? NetworkImage(imageUrl!) :
            AssetImage('assets/images/user.png')) as ImageProvider, // Или NetworkImage
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}