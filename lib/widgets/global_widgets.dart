import 'package:dor_chat_client/constants/constants.dart';
import 'package:dor_chat_client/widgets/clickable.dart';
import 'package:dor_chat_client/widgets/gardient_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


/// The default boxShadow List used in painting clickable items.
const List<BoxShadow> _shadowList = [
  BoxShadow(
    color: defaultShadowColor,
    offset: Offset(0.0, 2.0),
    spreadRadius: 0.0,
    blurRadius: 14.0,
  ),
];

/// The default box-decoration used for decoration the [ProfieImageAvatar].
const BoxDecoration kProfileImageAvatarDecoration = BoxDecoration(
  shape: BoxShape.circle,
  boxShadow: _shadowList,
);

/// A collection of Global Widgets to be used in various parts of the App.
class GlobalWidgets {
  /// A global widget that is used to render respective asset images
  /// as icons.
  static Widget assetImageToIcon(
      String imagePath, {
        double scale = 4.0,

        /// The Padding to be applied to the outter bounds of `this`
        /// [ImageToIcon] Widget.
        EdgeInsets iconPad = const EdgeInsets.all(7.5),

        /// A callback that fires when this widget is tapped.
        void Function()? onTap,
      }) {
    // ASSERTION LAYER.
    assert(
    iconPad != null,
    'The parameter "iconPad" cannot be null, please provide an acceptable value for the "iconPad" parameter',
    );

    // check if scale is null and assign it a default value of 4.0

    Widget _child = Padding(
      padding: iconPad,
      child: Image.asset(
        imagePath,
        scale: scale,
      ),
    );

    // checks if the onTap parameter is null, this widget is returned as it is
    // else it is wrapped in a [GestureDetector] Widget to detect taps.
    if (onTap != null) {
      _child = GestureDetector(
        onTap: onTap,
        child: _child,
      );
    }

    return _child;
  }

  /// A Widget to build the block UI for each settings option.
  static Widget buildSettingsBlock(
      {

        /// The description of the settings Tile.
        required String description,

        /// The child Widget to build as the body of the Settings block.
        required Widget body,

        /// The title for the Settings Panel or block
        required String title,

        /// An optional parameter to build the Title Widget.
        Widget? top,

        ///
        EdgeInsetsGeometry outerPadding =
        const EdgeInsets.symmetric(horizontal: 2.0, vertical: 16.0),

        //
        EdgeInsetsGeometry titlePadding = const EdgeInsets.all(8.0),

        //
        EdgeInsetsGeometry bodyPadding =
        const EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0)
        //const EdgeInsets.symmetric(vertical: 0.0, horizontal: 8.0),
      }) {
    // assertion layer
    assert(
    top != null || description != null,
    '''One of `description` or `titleBuilder` must be specified. 
      When the two are specified, the title Widget is given Priority.''',
    );

    var _textStyle = TextStyle(
      color: darkTextColor,
      fontFamily: 'Nunito',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    return Container(
      margin: outerPadding,
      decoration: BoxDecoration(
        border: Border.all(
          color: lightCardColor,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: titlePadding,
            constraints: BoxConstraints(
              minHeight: 50.0,
            ),
            decoration: BoxDecoration(
              color: lightCardColor,
            ),
            child: (top != null)
                ? top
                : Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  if (title != null)
                    TextSpan(
                      text: '$title' + ' ',
                      style: _textStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  TextSpan(
                    text: description,
                  ),
                ],
              ),
              style: _textStyle,
            ),
          ),
          if (body != null)
            Container(
              padding: bodyPadding,
              decoration: BoxDecoration(
                color: whiteCardColor,
              ),
              child: body,
            ),
        ],
      ),
    );
  }

  /// A widget to show a simple Alert Dialogue.
  static Future<void> showAlertDialogue(
      BuildContext context, {
        required String message,
        required String title,
        void onTap,
      }) async {
    //
    var _defaultTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Nunito',
      fontSize: 15,
      fontWeight: FontWeight.w500,
    );

    var _varryingTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: 'Nunito',
      fontSize: 16,
      fontWeight: FontWeight.w700,
    );

    String _resolveAlertTitle() {
      if (title != null && title != '') {
        return title;
      } else {
        return 'Alert!';
      }
    }

    var status = await showDialog<void>(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * 0.375,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.375,
            maxHeight: MediaQuery.of(context).size.height * 0.55,
            minWidth: MediaQuery.of(context).size.width * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 1.0,
            color: lightCardColor,
            child: Stack(
              fit: StackFit.expand,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  heightFactor: 0.7,
                  widthFactor: 1.0,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: _defaultTextStyle,
                          children: <InlineSpan>[
                            TextSpan(
                              text: ' ${_resolveAlertTitle()}\n ',
                              style: _varryingTextStyle,
                            ),
                            TextSpan(
                              text: ' $message ',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.3,
                  widthFactor: 1.0,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                      ),
                      onPressed: () {
                        // user has canceled the delete action.
                        Navigator.of(context).pop<void>();
                        // return false;
                      },
                      child: Text(
                        'OK',
                        style: _varryingTextStyle.copyWith(color: colorBlend02),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    return status;
  }

  static Future<void> showImagePickerDialogue({
    required BuildContext context,
    String title = 'Select an Image source',

    /// This function is called immediately after the image is picked.
    /// Here you can make use of the [PickedFile] returned in whatever
    /// Network request or any other usage you may have in mind..
    required Function(PickedFile) onImagePicked,
  }) async {
    PickedFile _imageFile;
    final ImagePicker _picker = ImagePicker();
    String _retrieveDataError;

    double _heightExtent = 0.355;

    // Called in-case the user interupts the file-picking process such as recieving a message and so o,
    // basically things that disturb the process in one way or the other.
    //
    Future<void> retrieveLostData() async {
      final LostData response = await _picker.getLostData();
      if (response.isEmpty) {
        return;
      }
      if (response.file != null) {
        if (response.type == RetrieveType.video) {
          return;
        } else if (response.type == RetrieveType.image) {
            _imageFile = (response.file)!;

        }
      } else {
        //_retrieveDataError = response.exception.code;

        //print('Error retrieving lost Data! [ERROR-CODE]: $_retrieveDataError');
      }
    }

    void _onImageButtonPressed(ImageSource source) async {
      // Initiate the pick Image Function.
      try {
        final pickedFile = await _picker.getImage(source: source);
        if (pickedFile == null) {
          // Add the retrieve lost data function.
          retrieveLostData();
        }
        if (pickedFile != null) {
          _imageFile = pickedFile;
          if (onImagePicked != null) onImagePicked(_imageFile);

          return;
        }
      } catch (error) {
        // log
        print('Error picking Image! [ERROR]: $error');

        return;
      }
    }

    //
    // var _defaultTextStyle = TextStyle(
    //   color: Colors.black,
    //   fontFamily: 'Nunito',
    //   fontSize: 15,
    //   fontWeight: FontWeight.w500,
    // );

    // var _varryingTextStyle = TextStyle(
    //   color: Colors.black,
    //   fontFamily: 'Nunito',
    //   fontSize: 16,
    //   fontWeight: FontWeight.w700,
    // );

    String _resolveAlertTitle() {
      if (title != null && title != '') {
        return title;
      } else {
        return 'Image Selection';
      }
    }

    Widget imageSelectionItem({
      required ImageSource source,
      required String sourceName,
      required Widget icon,
    }) {
      return InkWell(
        onTap: () {
          // Pop the dialogue and execute the image-picking Function.
          Navigator.of(context).pop();

          _onImageButtonPressed(source);
        },
        child: Container(
          margin: const EdgeInsets.all(8.0),
          padding: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: GradientWidget(
                  gradient: mainColorGradient,
                  child: icon,
                ),
              ),
              RichText(
                text: TextSpan(
                  style: defaultTextStyle,
                  children: [
                    TextSpan(
                      text: 'Pick from ',
                    ),
                    TextSpan(
                      text: '${sourceName}',
                      style: boldTextStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // show the image-picker dialogue
    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Container(
          margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * _heightExtent,
            horizontal: MediaQuery.of(context).size.width * 0.1,
          ),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.375,
            maxHeight: MediaQuery.of(context).size.height * 0.55,
            minWidth: MediaQuery.of(context).size.width * 0.75,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 1.0,
            color: lightCardColor,
            child: Stack(
              fit: StackFit.expand,
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FractionallySizedBox(
                  heightFactor: 0.25,
                  widthFactor: 1.0,
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(4.5),
                    child: Text(
                      ' "${_resolveAlertTitle()}"\n ',
                      style: boldTextStyle,
                    ),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.75,
                  widthFactor: 1.0,
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        imageSelectionItem(
                          source: ImageSource.camera,
                          sourceName: 'Camera',
                          icon: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                        imageSelectionItem(
                          source: ImageSource.gallery,
                          sourceName: 'Gallery',
                          icon: Icon(
                            Icons.photo_library,
                            color: Colors.white,
                            size: 24.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // return;
  }

  static void showLoadingIndicator({
    required BuildContext context,
    String? message,

    /// This determines whether or not the loading indicator overlay
    /// pops on pressing the back button.
    bool popOnBack = true,
    bool barrierDismissible = false,
  }) async {
    // show the loading indicator
    await showDialog(
      useSafeArea: true,
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // this will prevent the pressing of the back-button on Android from
            // poping the Loading indicator.
            return popOnBack;
          },
          child: Center(
            child: Container(
              // constraints: BoxConstraints(
              //     // minHeight: MediaQuery.of(context).size.height * 0.375,
              //     // maxHeight: MediaQuery.of(context).size.height * 0.55,
              //     // minWidth: MediaQuery.of(context).size.width * 0.75,
              //     // maxWidth: MediaQuery.of(context).size.width * 0.95,
              //     ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitDualRing(
                    color: colorBlend01,
                    size: 35.0,
                    lineWidth: 2.40,
                  ),
                  if (message != null)
                    Text(
                      message,
                      style: defaultTextStyle,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// This method closes any opened LoadingIndicator-Dialogue by poping the Route
  /// currently on top of the stack.
  ///
  /// This is equivalent to calling [Navigator.pop] from anywhere in the App.
  static void hideLoadingIndicator(BuildContext context) {
    Navigator.of(context).maybePop();
  }

  /// This funtion takes in a Function, `fn` to load, calls the showLoadingIndicator function to show
  /// a loading indicator and closes automatically when the given `fn` is done.
  static Future<void> indicatorIncoporatedFetch(
      void Function() fn, {
        required BuildContext context,
        String? message,
      }) async {
    assert(context != null,
    'The "context" provided is null! Please provide a non-null context');
    showLoadingIndicator(context: context, message: message);
    fn();
    hideLoadingIndicator(context);
    return;
  }
}

///
class ActionBox extends StatelessWidget {
  const ActionBox({
    Key? key,
    this.trailing,
    required this.message,
    required this.onTap,
    this.backgroundColor,
    this.shadowColor,
    this.overflow = TextOverflow.ellipsis,
    this.useSplash = true,
    this.automaticallyImplyTrailing = true,
    this.elevation = 2.1,
    this.clipBehavior = Clip.hardEdge,
    this.messageStyle,
    this.borderRadius,
    this.margin = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: 16.0),
    this.constraints,
  }) : super(key: key);

  /// The message to display in the box.
  final String message;

  /// The widget to display after the message.
  ///
  /// This is usually an icon button that can recieve a tap gesture.
  final Widget? trailing;

  /// The callback to be fired when this item is clicked or Tapped.
  final GestureTapCallback? onTap;

  /// Whether or not to wrap the whole action button in an InkWell
  /// widget to provided gesture ans splash reaction.
  ///
  /// Note if this is true, the default trailing widget will no longer respond to gesture taps
  /// instead the tap callback will be invoked whenever the box it itself tapped (anywhere).
  final bool useSplash;

  /// Whether or not to display the default trailing widget if no trailing widget
  /// is provided.
  ///
  /// Note that if no trailing widget is provided and this is false nothing will be
  /// displayed as the trailing widget.
  final bool automaticallyImplyTrailing;

  /// The padding to apply outside this widget.
  ///
  /// Defaults to `EdgeInsets.all(6.0)`.
  ///
  /// must not be null.
  final EdgeInsetsGeometry margin;

  /// By how much to elevate the box.
  ///
  /// Defaults to `2.1`.
  final double elevation;

  /// How the text should behave when there is an overflow.
  ///
  /// This is set to [TextOverflow.ellipsis] by default.
  final TextOverflow overflow;

  /// How the box should be clipped.
  final Clip clipBehavior;

  /// The padding to apply inside this widget.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0)`.
  ///
  /// must not be null.
  final EdgeInsetsGeometry padding;

  /// The border Radius to apply to the border of this widget.
  ///
  /// If null defaults to `BorderRadius.circular(13.0)`
  final BorderRadiusGeometry? borderRadius;

  /// The color with which to paint the notification box background.
  ///
  /// Defaults to the color provided by the [lightCardColor] const in "/lib/constant/color_constants.dart".
  final Color? backgroundColor;

  /// The color with which to paint the shadow behind the notification box.
  ///
  /// Defaults to the color provided by the [defaultShadowColor] const in "/lib/constant/color_constants.dart".
  final Color? shadowColor;

  /// The [TestStyle] to assign to the message Text displayed in the box.
  ///
  /// Default to the TextStyle defined by the [smallCharStyle] const in "/lib/constant/color_constants.dart".
  final TextStyle? messageStyle;

  /// The size constraints applied to the widget.
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    Widget? _trailing = trailing;

    if (automaticallyImplyTrailing && _trailing == null) {
      _trailing = useSplash
          ? Icon(
        CupertinoIcons.right_chevron,
        size: 30.0,
        color: colorBlend02,
      )
          : IconButton(
        icon: Icon(
          CupertinoIcons.right_chevron,
          size: 30.0,
          color: colorBlend02,
        ),
        onPressed: onTap,
      );
    }

    Widget current = Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              overflow: TextOverflow.ellipsis,
              style: messageStyle ?? smallBoldedCharStyle,
            ),
          ),
          // we make sure that if it is null (which suggest that "automaticallyImplyTrailing" is false)
          // we exclude the widget from being rendered to avoid error.
          if (_trailing != null) _trailing,
        ],
      ),
    );

    return Padding(
      padding: margin,
      child: ConstrainedBox(
        constraints: constraints ?? BoxConstraints(
          minHeight: 55.0,
          maxHeight: 80.0,
        ),
        child: Material(
          color: backgroundColor ?? whiteCardColor,
          shadowColor: defaultShadowColor,
          elevation: elevation,
          clipBehavior: clipBehavior,
          borderRadius: borderRadius ?? BorderRadius.circular(13.0),
          child: useSplash
              ? InkWell(
            child: current,
            onTap: onTap,
          )
              : current,
        ),
      ),
    );
  }
}

/// A Widget that can be configured to display information. It also allows for a
/// Label to be stacked above it.
class DescriptionBanner extends StatelessWidget {
  const DescriptionBanner({
    Key? key,
    required this.message,
    this.leading,
    this.trailing,
    required this.label,
    this.textStyle,
    this.automaticallyImplyTrailing = true,
    this.enableFeedback = true,
    this.borderRadius,
    this.onTap,
    this.onLongPressed,
    this.overflow = TextOverflow.ellipsis,
    this.margin = const EdgeInsets.all(6.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
    this.constraints,
  }) : super(key: key);

  /// The message to display in the box.
  final String message;

  /// The widget to display after the message.
  final Widget? leading;
  /// This is usually an icon button that can recieve a tap gesture.
  final Widget? trailing;

  /// The widget to stacked above the card.
  final Widget label;

  /// Whether or not to display the default trailing widget if no trailing widget
  /// is provided.
  final bool automaticallyImplyTrailing;

  /// Whether or not to enable the clicking/tapping of this widget and allow the
  /// shrinking and unshrinking effect of the clickable widget.
  final bool enableFeedback;

  /// The callback to be fired when this item is clicked or Tapped.
  final GestureTapCallback? onTap;

  /// The callback to be fired when this item is Long-pressed.
  final GestureTapCallback? onLongPressed;

  /// How the text should behave when there is an overflow.
  ///
  /// This is set to [TextOverflow.ellipsis] by default.
  final TextOverflow overflow;

  /// The textStyle with which to draw the banner message.
  ///
  /// This defaults to the value [smallCharStyle] as declared in
  /// the "color_constant.dart" file in the "/lib/constant/" directory.
  final TextStyle? textStyle;

  /// The padding to apply outside this widget.
  ///
  /// Defaults to `EdgeInsets.all(6.0)`.
  ///
  /// must not be null.
  final EdgeInsetsGeometry margin;

  /// The padding to apply inside this widget.
  ///
  /// Defaults to `EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0)`.
  ///
  /// must not be null.
  final EdgeInsetsGeometry padding;

  /// The border Radius to apply to the border of this widget.
  ///
  /// If null defaults to `BorderRadius.circular(13.0)`
  final BorderRadiusGeometry? borderRadius;

  /// The size constraints applied to the widget.
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    // If the trailing is not provided we return a default
    // trailing "chevron_left" Icon.
    Widget? _trailing = trailing;

    // If automatically imply trailing is true
    // we set the value of _trailing to the default trailing
    // widget.
    if (automaticallyImplyTrailing) {
      _trailing ??= Icon(
        CupertinoIcons.right_chevron,
        size: 30.0,
        color: colorBlend02,
      );
    }

    return Clickable(
      onTap: onTap,
      onLongPressed: onLongPressed,
      enableFeedback: enableFeedback && onTap != null,
      child: Stack(
        children: [
          Container(
            margin: margin,
            constraints: constraints ?? BoxConstraints(
              minHeight: 75.0,
              maxHeight: 90.5,
            ),
            decoration: BoxDecoration(
              color: lightCardColor,
              borderRadius: borderRadius ?? BorderRadius.circular(13.0),
            ),
            child: Padding(
              padding: padding,
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if(leading != null) leading!,
                        if (leading != null) SizedBox(width: 5.0),
                        Expanded(
                          child: Text(
                            message,
                            overflow: overflow,
                            style: textStyle ?? mediumBoldedCharStyle,
                          ),
                        ),

                      ],
                    ),
                  ),
                  if (_trailing != null) _trailing,
                ],
              ),
            ),
          ),
          if (label != null) label,
        ],
      ),
    );
  }
}

/// A Wrapper around the [ActionBox] widget that is in fact an [ActionBox] but should be used specifically
/// as a notification box.
class NotificationBox extends ActionBox {
  NotificationBox({
    Key? key,
    required String message,
    required void Function() onTap,
    Color backgroundColor = lightCardColor,
    TextStyle messageStyle = smallCharStyle,
    BorderRadiusGeometry? borderRadius,
    EdgeInsetsGeometry margin = const EdgeInsets.all(6.0),
    EdgeInsetsGeometry padding =
    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
    BoxConstraints? constraints,
  }) : super(
    key: key,
    message: message,
    onTap: onTap,
    backgroundColor: backgroundColor,
    messageStyle: messageStyle,
    borderRadius: borderRadius,
    useSplash: false,
    margin: margin,
    elevation: 0.0,
    padding: padding,
    constraints: constraints,
  );
}

/// A Widget for creating circle Profile Avatars.
///
/// The constructor [ProfileImageAvatar.mutable] is specially adapted for situations where the expected image
/// may not be available at hand.
class ProfileImageAvatar extends StatelessWidget {
  /// The default private constructor for the [ProfileImageAvatar] widget.
  ProfileImageAvatar({
    Key? key,
    required this.imageProvider,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.decoration,
    this.child,
    this.radius,
    this.minRadius,
    this.maxRadius,
  })  : assert(imageProvider != null,
  'The parameter, "imageProvider" must be provided'),
        assert(radius == null || (minRadius == null && maxRadius == null)),
        super(key: key);

  /// Create a [ProfileImageAvatar] widget from a network source.
  ProfileImageAvatar.network({
    Key? key,
    required String url,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.decoration,
    this.child,
    this.radius,
    this.minRadius,
    this.maxRadius,
    BoxFit fit = BoxFit.cover,
     double? height,
     double? width,
    double scale = 1.0,
    Color? color,
    WidgetBuilder? placholderBuilder,
    WidgetBuilder? errorBuilder,
    void Function()? onError,
  })  :assert(radius == null || (minRadius == null && maxRadius == null)),
        imageProvider = Image.network(
          url,
          fit: fit,
          width: width,
          height: height,
          scale: scale,
          color: color,
          errorBuilder: errorBuilder == null
              ? null
              : (BuildContext context, Object object, StackTrace? stackTrace) {
            if(onError!=null) onError();
            return errorBuilder(context);
          },
          loadingBuilder: placholderBuilder == null
              ? null
              : (BuildContext context, Widget child,
              ImageChunkEvent? chunkEvent) {
            return placholderBuilder(context);
          },
        ).image,
        super(key: key);

  /// Create a [ProfileImageAvatar] widget from the asset.
  ProfileImageAvatar.asset({
    Key? key,
    required String uri,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.decoration,
    this.child,
    this.radius,
    this.minRadius,
    this.maxRadius,
    BoxFit fit = BoxFit.cover,
    double? height,
    double? width,
    double scale = 1.0,
    Color? color,
    WidgetBuilder? errorBuilder,
    void Function()? onError,
  })  : assert(uri != null, 'The value of "uri" cannot be null!'),
        assert(radius == null || (minRadius == null && maxRadius == null)),
        imageProvider = Image.asset(
          uri,
          fit: fit,
          width: width,
          height: height,
          scale: scale,
          color: color,
          errorBuilder: errorBuilder == null
              ? null
              : (BuildContext context, Object object, StackTrace? stackTrace) {
            if(onError!=null) {onError();}
            return errorBuilder(context);
          },
        ).image,
        super(key: key);

  /// A Factory constructor for creating a [ProfileImageAvatar] whose imageProvider can be swpped out
  /// depending on whether the [actualImage] is `null` or not and replaced by another placholder imageProvider,
  /// [placeholderImage].
  ///
  /// The [placeholderImage] should be an image that is readily available like an [AssetImage] or a [MemoryImage]
  /// since it will be considered as a placeholder.
  ///
  /// Note that if the value [actualImageIsAvailable] is set to `false`, the [placeholderImage] will be rendered
  /// whether or not the [actualImage] is non-null.
  /// For this cause [actualImageIsAvailable] is set to `true` by default meaning without providing the [actualImage]
  /// value the [placeholderImage] will be loaded instead when and only when the [actualImage] is null.
  factory ProfileImageAvatar.mutable({
    required ImageProvider actualImage,
    required ImageProvider placeholderImage,
    bool actualImageIsAvailable = true,
    Color backgroundColor = const Color(0xFFFFFFFF),
    Decoration? decoration,
    Widget? child,
    double? radius,
    double? minRadius,
    double? maxRadius,
  }) {
    assert(placeholderImage != null,
    'The parameter, "placeholderImage" must be provided!');
    assert(radius == null || (minRadius == null && maxRadius == null));

    final bool _isAvialble = actualImage != null && actualImageIsAvailable;
    final _imageProvider = _isAvialble ? actualImage : placeholderImage;

    return ProfileImageAvatar(
      imageProvider: _imageProvider,
      backgroundColor: backgroundColor,
      decoration: decoration,
      child: child,
      radius: radius,
      minRadius: minRadius,
      maxRadius: maxRadius,
    );
  }

  final ImageProvider imageProvider;

  /// The widget to display above the avatar.
  final Widget? child;

  final double? radius;

  /// The minimum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [minRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to zero.
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [minRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [minRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? minRadius;

  /// The maximum size of the avatar, expressed as the radius (half the
  /// diameter).
  ///
  /// If [maxRadius] is specified, then [radius] must not also be specified.
  ///
  /// Defaults to [double.infinity].
  ///
  /// Constraint changes are animated, but size changes due to the environment
  /// itself changing are not. For example, changing the [maxRadius] from 10 to
  /// 20 when the [CircleAvatar] is in an unconstrained environment will cause
  /// the avatar to animate from a 20 pixel diameter to a 40 pixel diameter.
  /// However, if the [maxRadius] is 40 and the [CircleAvatar] has a parent
  /// [SizedBox] whose size changes instantaneously from 20 pixels to 40 pixels,
  /// the size will snap to 40 pixels instantly.
  final double? maxRadius;

  final Color? backgroundColor;

  /// The decoration with which to decorate the [ProfileImageAvatar].
  final Decoration? decoration;

  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration ?? kProfileImageAvatarDecoration,
      child: CircleAvatar(
        backgroundColor: backgroundColor,
        backgroundImage: imageProvider,
        radius: radius,
        minRadius: minRadius,
        maxRadius: maxRadius,
        child: child,
      ),
    );
  }
}