import 'package:flutter/material.dart';
import 'package:pujcovadlo_client/features/profiles/responses/user_response.dart';

class ProfileImage extends StatelessWidget {
  final UserResponse user;
  final double radius;

  const ProfileImage({required this.user, required this.radius, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      //backgroundImage: NetworkImage(widget.item.owner?.profileImage),
      backgroundImage: AssetImage("images/user_placeholder.png"),
    );
  }
}
