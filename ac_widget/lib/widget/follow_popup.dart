import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FollowPopup extends StatefulWidget {
  const FollowPopup({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.follow,
    this.offsetRatio = 0.2,
  });

  final double width;
  final double height;
  final Widget child;
  final Widget? follow;

  ///浮窗相对于组件的偏移距离
  final double offsetRatio;

  @override
  State<FollowPopup> createState() => _FollowPopupState();
}

class _FollowPopupState extends State<FollowPopup> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: widget.child,
        onHover: (PointerHoverEvent event) {
          setState(() {
            _showOverlay(context, event.position);
          });
        },
        onExit: (PointerExitEvent event) {
          _removeOverlay();
          setState(() {});
        },
      ),
    );
  }

  OverlayEntry? _overlayEntry;

  void _showOverlay(
    BuildContext context,
    Offset offset,
  ) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + (widget.width * widget.offsetRatio),
        top: offset.dy - (widget.height * widget.offsetRatio),
        child: widget.follow ??
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                '浮窗示例',
                style: TextStyle(
                  color: Colors.lightGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
