
import 'package:dor_chat_client/constants/constants.dart';
import 'package:dor_chat_client/widgets/global_widgets.dart';
import 'package:flutter/material.dart';

/// A customAppBar that can be used as a Widget outside the [Scaffold] and can also be used inside the
/// Material [Scaffold] as an [AppBar].
///
/// Note: You must either provide the "title" or the "customTitleBuilder" parameter and
/// the parameter "icon" cannot be null.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    this.title,
    this.trailing,
    this.color = Colors.black,
    this.customTitle,
    this.hasTopPadding = false,
    this.showAppLogo = false,
    this.hasBackButton = true,
    this.trailingPad = 5.0,
    this.onPop,
  })  :
  // add necessary assertions.
        //assert(trailing != null, 'The parameter trailing cannot be null'),
        assert((title == null) != (customTitle == null),
        'One of "title" and "customTitleBuilder" must be null, You can only specify one of the two!'),
        super(key: key);

  CustomAppBar.subPage({
    required String subPageTitle,
    this.color=Colors.blue,
    this.hasBackButton = true,
    this.hasTopPadding = false,
    this.showAppLogo = true,
    this.trailingPad = 5.0,
    this.onPop,
  })  : this.trailing = Padding(
    padding: EdgeInsets.only(left: 10.0),
    child: Text(
      subPageTitle,
      style: TextStyle(
        color: color,
        fontSize: 22,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
        this.title = '',
        this.customTitle = SizedBox.shrink();

  /// The `title` for this tile.
  final String? title;

  /// This denotes the icon widget that is placed in the Appbar .
  final Widget? trailing;

  /// Determine whether to include a back-button at
  /// start of the tile (same as trailing icon in the original Appbar class).
  final bool hasBackButton;

  /// The Color of the title text. Defaults to `Colors.black`
  final Color color;

  /// Determines whether to add a Padding to the Top of the AppBar in a case where it is used
  /// as the `appBar` parameter of the [Scaffold] widget.
  final bool hasTopPadding;

  /// Use this to build a custom title Widget for the [CustomAppbar].
  final Widget? customTitle;

  /// Whether to show the App's Logo at the center of the App Bar.
  /// Must not be null.
  final bool showAppLogo;

  /// This is an optional Callback called immediately the backbutton (if enabled) is clicked.
  ///
  /// You can pass in this parameter to override the default pop behavour of the backbutton
  /// when pressed.
  ///
  /// Note: You will have to call the pop function yourself if you intend to pop the Current Route when
  /// the back-Button is clicked.
  ///
  /// Note: if `hasBackButton` is false or null, this function won't fire as the backbutton will
  /// be hiddden.
  final void Function()? onPop;

  /// This determines how much padding (in pixels) to add to the back to the trialing widget.
  ///
  /// The defualt is 5(px).
  final double trailingPad;

  @override
  Widget build(BuildContext context) {
    // This holds the value for the topPadding of the AppBar.
    double topPadding = MediaQuery.of(context).viewPadding.top;

    return Padding(
      padding:
      (hasTopPadding) ? EdgeInsets.only(top: topPadding) : EdgeInsets.zero,
      child: Container(
        margin: EdgeInsets.only(top: 5.0),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (hasBackButton)
                    InkWell(
                      splashColor: colorBlend02.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: onPop ??
                              () {
                            // Pop the current context.
                            Navigator.of(context).maybePop();
                          },
                      child: GlobalWidgets.assetImageToIcon(
                        'assets/images/back_arrow.png',
                      ),
                    ),
                  customTitle??
                      Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      title!,
                      style: TextStyle(
                        color: color,
                        fontSize: 22,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              if (showAppLogo)
                GlobalWidgets.assetImageToIcon('https://picsum.photos/200/300'),
              Padding(
                padding: EdgeInsets.only(right: trailingPad),
                child: trailing,
              ),
              // show App Logo.
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}