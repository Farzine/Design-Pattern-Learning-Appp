

// lib/widgets/circular_bottom_navigation.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'tab_item.dart';

typedef CircularBottomNavSelectedCallback = Function(int? selectedPos);

class CircularBottomNavigation extends StatefulWidget {
  final List<TabItem> tabItems;
  final int selectedPos;
  final double barHeight;
  final Color? barBackgroundColor;
  final Gradient? barBackgroundGradient;
  final double circleSize;
  final double circleStrokeWidth;
  final double iconsSize;
  final Color selectedIconColor;
  final Color normalIconColor;
  final Duration animationDuration;
  final List<BoxShadow>? backgroundBoxShadow;
  final CircularBottomNavSelectedCallback? selectedCallback;
  final CircularBottomNavigationController? controller;

  /// If true, allows a selected tab icon to execute its callback even if it's
  /// already selected.
  final bool allowSelectedIconCallback;

  CircularBottomNavigation(
    this.tabItems, {
    this.selectedPos = 0,
    this.barHeight = 60,
    barBackgroundColor,
    this.barBackgroundGradient,
    this.circleSize = 58,
    this.circleStrokeWidth = 4,
    this.iconsSize = 32,
    this.selectedIconColor = Colors.white,
    this.normalIconColor = Colors.black,
    this.animationDuration = const Duration(milliseconds: 300),
    this.selectedCallback,
    this.controller,
    this.allowSelectedIconCallback = false,
    backgroundBoxShadow,
  })  : backgroundBoxShadow = backgroundBoxShadow ??
                [BoxShadow(color: Colors.grey, blurRadius: 2.0)],
            barBackgroundColor =
                (barBackgroundGradient == null && barBackgroundColor == null)
                    ? Colors.purple.shade100
                    : barBackgroundColor,
            assert(
                barBackgroundColor == null || barBackgroundGradient == null,
                "Both barBackgroundColor and barBackgroundGradient can't be not null."),
            assert(tabItems.length != 0, "tabItems is required");

  @override
  State<StatefulWidget> createState() => _CircularBottomNavigationState();
}

class _CircularBottomNavigationState extends State<CircularBottomNavigation>
    with TickerProviderStateMixin {
  Curve _animationsCurve = Curves.ease;

  late AnimationController itemsController;
  late Animation<double> selectedPosAnimation;
  late Animation<double> itemsAnimation;

  late List<double> _itemsSelectedState;

  int? selectedPos;
  int? previousSelectedPos;

  CircularBottomNavigationController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller;
      previousSelectedPos = selectedPos = _controller!.value;
    } else {
      previousSelectedPos = selectedPos = widget.selectedPos;
      _controller = CircularBottomNavigationController(selectedPos);
    }

    _controller!.addListener(_newSelectedPosNotify);

    _itemsSelectedState = List.generate(widget.tabItems.length, (index) {
      return selectedPos == index ? 1.0 : 0.0;
    });

    itemsController =
        AnimationController(vsync: this, duration: widget.animationDuration);
    itemsController.addListener(() {
      setState(() {
        _itemsSelectedState.asMap().forEach((i, value) {
          if (i == previousSelectedPos) {
            _itemsSelectedState[previousSelectedPos!] =
                1.0 - itemsAnimation.value;
          } else if (i == selectedPos) {
            _itemsSelectedState[selectedPos!] = itemsAnimation.value;
          } else {
            _itemsSelectedState[i] = 0.0;
          }
        });
      });
    });

    selectedPosAnimation = makeSelectedPosAnimation(
        selectedPos!.toDouble(), selectedPos!.toDouble());

    itemsAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: itemsController, curve: _animationsCurve));
  }

  Animation<double> makeSelectedPosAnimation(double begin, double end) {
    return Tween(begin: begin, end: end).animate(
        CurvedAnimation(parent: itemsController, curve: _animationsCurve));
  }

  void onSelectedPosAnimate() {
    setState(() {});
  }

  void _newSelectedPosNotify() {
    _setSelectedPos(_controller!.value);
  }

  @override
  Widget build(BuildContext context) {
    double maxShadowHeight = (widget.backgroundBoxShadow ?? []).isNotEmpty
        ? widget.backgroundBoxShadow!.map((e) => e.blurRadius).reduce(max)
        : 0.0;
    double fullWidth = MediaQuery.of(context).size.width;
    double fullHeight = widget.barHeight +
        (widget.circleSize / 2) +
        widget.circleStrokeWidth +
        maxShadowHeight;
    double sectionsWidth = fullWidth / widget.tabItems.length;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    // Create the boxes Rect
    List<Rect> boxes = [];
    widget.tabItems.asMap().forEach((i, tabItem) {
      double left =
          isRTL ? fullWidth - (i + 1) * sectionsWidth : i * sectionsWidth;
      double top = fullHeight - widget.barHeight;
      double right = left + sectionsWidth;
      double bottom = fullHeight;
      boxes.add(Rect.fromLTRB(left, top, right, bottom));
    });

    List<Widget> children = [];

    // Transparent background for the entire component
    children.add(Container(
      width: fullWidth,
      height: fullHeight,
    ));

    // Bar background
    children.add(
      Positioned(
        child: Container(
          width: fullWidth,
          height: widget.barHeight,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: widget.barBackgroundColor,
            gradient: widget.barBackgroundGradient,
            boxShadow: widget.backgroundBoxShadow,
          ),
        ),
        top: fullHeight - widget.barHeight,
        left: 0,
      ),
    );

    // Circle handle
    children.add(
      Positioned(
        child: Container(
          width: widget.circleSize,
          height: widget.circleSize,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: widget.circleSize,
                height: widget.circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.tabItems[selectedPos!].circleColor,
                  boxShadow: widget.backgroundBoxShadow,
                ),
              ),
            ],
          ),
        ),
        left: isRTL
            ? fullWidth -
                ((selectedPosAnimation.value * sectionsWidth) +
                    (sectionsWidth / 2) +
                    (widget.circleSize / 2))
            : (selectedPosAnimation.value * sectionsWidth) +
                (sectionsWidth / 2) -
                (widget.circleSize / 2),
        top: maxShadowHeight,
      ),
    );

    // Icons and Texts of items
    boxes.asMap().forEach((int pos, Rect r) {
      // Icon
      Color iconColor = pos == selectedPos
          ? widget.selectedIconColor
          : widget.normalIconColor;
      double scaleFactor = pos == selectedPos ? 1.2 : 1.0;
      children.add(
        Positioned(
          child: Transform.scale(
            scale: scaleFactor,
            child: Icon(
              widget.tabItems[pos].icon,
              size: widget.iconsSize,
              color: iconColor,
            ),
          ),
          left: r.center.dx - (widget.iconsSize / 2),
          top: r.center.dy -
              (widget.iconsSize / 2) -
              (_itemsSelectedState[pos] *
                  ((widget.barHeight / 2) + widget.circleStrokeWidth)),
        ),
      );

      // Text
      double textHeight = fullHeight - widget.circleSize;
      double opacity = _itemsSelectedState[pos];
      opacity = opacity.clamp(0.0, 1.0);
      children.add(Positioned(
        child: Container(
          width: r.width,
          height: textHeight,
          child: Center(
            child: Opacity(
              opacity: opacity,
              child: Text(
                widget.tabItems[pos].title,
                textAlign: TextAlign.center,
                style: widget.tabItems[pos].labelStyle,
              ),
            ),
          ),
        ),
        left: r.left,
        top: r.top +
            (widget.circleSize / 2) -
            (widget.circleStrokeWidth * 2) +
            ((1.0 - _itemsSelectedState[pos]) * textHeight),
      ));

      if (pos != selectedPos) {
        children.add(
          Positioned.fromRect(
            child: GestureDetector(
              onTap: () {
                _controller!.value = pos;
              },
            ),
            rect: r,
          ),
        );
      } else if (widget.allowSelectedIconCallback == true) {
        Rect selectedRect = Rect.fromLTWH(r.left, 0, r.width, fullHeight);
        children.add(
          Positioned.fromRect(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(40.0)),
              child: GestureDetector(onTap: _selectedCallback),
            ),
            rect: selectedRect,
          ),
        );
      }
    });

    return Directionality(
      textDirection: TextDirection.ltr, // Changed to LTR unless your app is RTL
      child: Stack(
        children: children,
      ),
    );
  }

  void _setSelectedPos(int? pos) {
    if (pos == null) return;
    if (pos == selectedPos && !widget.allowSelectedIconCallback) return;

    previousSelectedPos = selectedPos;
    selectedPos = pos;

    itemsController.forward(from: 0.0);

    selectedPosAnimation =
        makeSelectedPosAnimation(previousSelectedPos!.toDouble(), selectedPos!.toDouble());
    selectedPosAnimation.addListener(onSelectedPosAnimate);

    _selectedCallback();
  }

  void _selectedCallback() {
    if (widget.selectedCallback != null) {
      widget.selectedCallback!(selectedPos);
    }
  }

  @override
  void dispose() {
    super.dispose();
    itemsController.dispose();
    _controller!.removeListener(_newSelectedPosNotify);
  }
}

class CircularBottomNavigationController extends ValueNotifier<int?> {
  CircularBottomNavigationController(int? value) : super(value);
}
