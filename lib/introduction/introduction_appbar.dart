import 'package:flutter/material.dart';

class IntroductionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function()? onSignInPressed;
  final Function()? onPressed;

  const IntroductionAppBar({
    Key? key,
    required this.title,
    this.onSignInPressed,
    this.onPressed
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Theme.of(context).primaryColor,
      leading: Padding(
        padding: EdgeInsets.all(8.0),
        child: Image.asset('assets/proudme_logo_mini.png'),
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(
            'Project Team',
            style: TextStyle(color: Colors.white),
          ),
        ),
        IconButton(
          icon: Icon(Icons.person, color: Colors.white),
          onPressed: onSignInPressed
        ),
      ],
    );
  }
}
