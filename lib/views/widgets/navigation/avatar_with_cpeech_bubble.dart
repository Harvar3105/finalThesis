import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarWithSpeechBubble extends StatefulWidget {
  final ImageProvider avatarImage;
  final VoidCallback? onButton1Pressed;
  final VoidCallback? onButton2Pressed;
  final VoidCallback? onButton3Pressed;

  const AvatarWithSpeechBubble({
    Key? key,
    required this.avatarImage,
    this.onButton1Pressed,
    this.onButton2Pressed,
    this.onButton3Pressed,
  }) : super(key: key);

  @override
  State<AvatarWithSpeechBubble> createState() => _AvatarWithSpeechBubbleState();
}

class _AvatarWithSpeechBubbleState extends State<AvatarWithSpeechBubble> {
  OverlayEntry? _overlayEntry;

  void _showOverlay(BuildContext context) {
    if (_overlayEntry != null) return;

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx - 45,
        top: offset.dy + 60,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 200,
            maxHeight: 54*2,
          ),
          child: Bubble(
            nip: BubbleNip.no,
            color: Colors.white,
            borderWidth: 1,
            borderColor: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onButton1Pressed?.call();
                    _hideOverlay();
                  },
                  child: const Text('Logout'),
                ),
                TextButton(
                  onPressed: () {
                    widget.onButton2Pressed?.call();
                    _hideOverlay();
                  },
                  child: const Text('To profile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlayEntry == null) {
          _showOverlay(context);
        } else {
          _hideOverlay();
        }
      },
      child: CircleAvatar(
        backgroundImage: widget.avatarImage,
        radius: 30,
      ),
    );
  }
}