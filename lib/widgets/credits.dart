import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Crdits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 0.5 * MediaQuery.of(context).size.width * (1 - 1 / 1.61803398875),
                  vertical: 0.5 * (MediaQuery.of(context).size.width - MediaQuery.of(context).padding.vertical) * (1 - 1 / 1.61803398875),
                ),
                child: Text(
                  AppLocalizations.of(context).creditsText,
                  style: Theme.of(context).textTheme.caption.copyWith(height: 1.5),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: 30 * 1.61803398875,
              child: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  size: 34,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
