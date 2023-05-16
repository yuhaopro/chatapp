import 'package:flutter/material.dart';
class GroupInviteCount extends StatelessWidget {
  const GroupInviteCount({Key? key, required this.widget}) : super(key: key);
  final Widget widget;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: widget,
    );
  }
}
