import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BouncyTap extends StatefulWidget {
  const BouncyTap({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.pressedScale = 0.60,
    this.downDuration = const Duration(milliseconds: 300),
    this.upDuration = const Duration(milliseconds: 20),
    this.upCurve = Curves.elasticOut,
    this.haptics = true,

    // 👇 ensures bounce is visible even on very quick taps
    this.awaitBounce = true,
    this.minDownHold = const Duration(milliseconds: 60),
    this.afterUpHold = const Duration(milliseconds: 5),

    this.splashColor,
    this.highlightColor,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;
  final double pressedScale;
  final Duration downDuration;
  final Duration upDuration;
  final Curve upCurve;
  final bool haptics;

  /// Play a short press-in + bounce before calling onTap
  final bool awaitBounce;
  final Duration minDownHold; // ensure user sees press-in
  final Duration afterUpHold; // small overshoot time

  final Color? splashColor;
  final Color? highlightColor;

  @override
  State<BouncyTap> createState() => _BouncyTapState();
}

class _BouncyTapState extends State<BouncyTap> {
  bool _pressed = false;
  DateTime? _downAt;
  bool _runningTap = false;

  void _setPressed(bool v) {
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? widget.pressedScale : 1.0,
      duration: _pressed ? widget.downDuration : widget.upDuration,
      curve: _pressed ? Curves.easeOutCubic : widget.upCurve,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: widget.borderRadius,
          splashColor: widget.splashColor ?? Colors.white.withOpacity(0.12),
          highlightColor:
              widget.highlightColor ?? Colors.white.withOpacity(0.05),

          onTapDown: (_) {
            _downAt = DateTime.now();
            _setPressed(true); // press-in instantly on touch
          },
          onTapCancel: () {
            _setPressed(false);
          },
          onTapUp: (_) async {
            // If we want to show the bounce first, let onTap handle timing
            if (!widget.awaitBounce) {
              _setPressed(false);
            }
          },

          onTap: () async {
            if (_runningTap) return; // protect against double taps during anim
            _runningTap = true;

            if (widget.haptics) HapticFeedback.selectionClick();

            if (widget.awaitBounce) {
              // ensure the "down" state is visible at least minDownHold
              final elapsed =
                  _downAt == null
                      ? widget.minDownHold
                      : DateTime.now().difference(_downAt!);
              if (elapsed < widget.minDownHold) {
                await Future.delayed(widget.minDownHold - elapsed);
              }

              _setPressed(false); // release -> bounce (elasticOut)
              await Future.delayed(
                widget.afterUpHold,
              ); // tiny time to show overshoot
            } else {
              _setPressed(false);
            }

            widget.onTap?.call();
            _runningTap = false;
          },
          child: Material(
            color: Colors.transparent, // 👉 try giving a background
            child: InkWell(
              borderRadius: widget.borderRadius,
              splashColor:
                  widget.splashColor ??
                  Colors.blue.withOpacity(0.2), // customize
              highlightColor:
                  widget.highlightColor ?? Colors.blue.withOpacity(0.1),
              onTapDown: (_) {
                _downAt = DateTime.now();
                _setPressed(true);
              },
              onTapCancel: () {
                _setPressed(false);
              },
              onTapUp: (_) async {
                if (!widget.awaitBounce) {
                  _setPressed(false);
                }
              },
              onTap: () async {
                if (_runningTap) return;
                _runningTap = true;

                if (widget.haptics) HapticFeedback.selectionClick();

                if (widget.awaitBounce) {
                  final elapsed =
                      _downAt == null
                          ? widget.minDownHold
                          : DateTime.now().difference(_downAt!);
                  if (elapsed < widget.minDownHold) {
                    await Future.delayed(widget.minDownHold - elapsed);
                  }
                  _setPressed(false);
                  await Future.delayed(widget.afterUpHold);
                } else {
                  _setPressed(false);
                }

                widget.onTap?.call();
                _runningTap = false;
              },
              child: Material(
                color: Colors.transparent, // 👉 try giving a background
                child: InkWell(
                  borderRadius: widget.borderRadius,
                  splashColor: widget.splashColor ?? Colors.blue.withOpacity(0.2), // customize
                  highlightColor: widget.highlightColor ?? Colors.blue.withOpacity(0.1),
                  onTapDown: (_) {
                    _downAt = DateTime.now();
                    _setPressed(true);
                  },
                  onTapCancel: () {
                    _setPressed(false);
                  },
                  onTapUp: (_) async {
                    if (!widget.awaitBounce) {
                      _setPressed(false);
                    }
                  },
                  onTap: () async {
                    if (_runningTap) return;
                    _runningTap = true;

                    if (widget.haptics) HapticFeedback.selectionClick();

                    if (widget.awaitBounce) {
                      final elapsed = _downAt == null
                          ? widget.minDownHold
                          : DateTime.now().difference(_downAt!);
                      if (elapsed < widget.minDownHold) {
                        await Future.delayed(widget.minDownHold - elapsed);
                      }
                      _setPressed(false);
                      await Future.delayed(widget.afterUpHold);
                    } else {
                      _setPressed(false);
                    }

                    widget.onTap?.call();
                    _runningTap = false;
                  },
                  child: widget.child,
                ),
              ),

            ),
          ),
        ),
      ),
    );
  }
}
