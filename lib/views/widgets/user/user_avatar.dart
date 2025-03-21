import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.url, this.radius});

  final String? url;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: url != null
          ? NetworkImage(url!)
          : const AssetImage('assets/images/user_icon.png') as ImageProvider,
    );
  }
}