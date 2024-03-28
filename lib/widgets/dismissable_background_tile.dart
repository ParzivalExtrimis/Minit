import 'package:flutter/material.dart';

class DissmissableBackgroundTile extends StatelessWidget {
  const DissmissableBackgroundTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      // shape: const RoundedRectangleBorder(
      //   borderRadius: BorderRadius.all(Radius.circular(12)),
      // ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Icon(Icons.delete,
              size: (Theme.of(context).iconTheme.size ?? 16) * 1.8),
        ),
      ),
    );
  }
}
