import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() { 
    WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); // /projects instead of /#/projects
  // Builds the semantics tree so screen readers and crawlers get real text
  SemanticsBinding.instance.ensureSemantics();
  runApp(const PortfolioApp());}

const kBg = Color(0xFF0A0A0C);
const kAcc = Color(0xFFFF5A36);

/// Smoothed mouse position, -1..1 on both axes (0,0 = screen centre).
/// Used by the extruded headlines. (Cards, chips and buttons use their own
/// local hover position in Tilt3D.) The background does NOT use it.
final ValueNotifier<Offset> gMouse = ValueNotifier<Offset>(Offset.zero);

// ───────────────────────── IMAGE ASSETS (edit paths here) ─────────────────────────
// Every image below is OPTIONAL. If a file is missing, the app falls back to
// the code-drawn version, so nothing crashes while you add your pictures.
class Pics {
  // First scene
  static const heroBg = 'assets/images/hero_bg.jpg'; // full-screen first image
  static const portrait = 'assets/images/camera.jpg'; // photo of you

  // Helicopter (transparent PNGs, helicopter facing RIGHT)
  static const heliBody = 'assets/images/sky/heli_body.png';
  static const heliRotor = 'assets/images/sky/heli_rotor.png'; // optional

  // Building layers (transparent PNGs, bottom-aligned skyline)
  static const cityFar = 'assets/images/sky/city_far.png';
  static const cityMid = 'assets/images/sky/city_mid.png';
  static const cityNear = 'assets/images/sky/city_near.png';

  // Where the rotor sits on the helicopter image (fractions of image size)
  static const rotorAnchor = Offset(.50, .10);
  static const rotorWidthFrac = 1.0; // rotor image width / body image width
}

TextStyle disp(double s, {Color c = Colors.white}) =>
    GoogleFonts.bebasNeue(fontSize: s, color: c, height: .95, letterSpacing: 1);
TextStyle body(double s,
        {Color c = const Color(0xCCFFFFFF),
        FontWeight w = FontWeight.w400,
        double ls = 0}) =>
    GoogleFonts.inter(
        fontSize: s, color: c, height: 1.6, fontWeight: w, letterSpacing: ls);

Future<void> open(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

double c01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

/// Loads an asset as a raw image for the painter. Returns null if missing.
Future<ui.Image?> loadUiImage(String asset) async {
  try {
    final data = await rootBundle.load(asset);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  } catch (_) {
    return null;
  }
}

// ───────────────────────── animation widgets ─────────────────────────

/// Gives every widget inside a scene its distance from the camera (-1..1).
class SceneT extends InheritedWidget {
  const SceneT({super.key, required this.t, required super.child});
  final double t;
  static double of(BuildContext c) =>
      c.dependOnInheritedWidgetOfExactType<SceneT>()?.t ?? 0;
  @override
  bool updateShouldNotify(SceneT o) => o.t != t;
}

/// Drifts with scroll for a depth feel.
class Parallax extends StatelessWidget {
  const Parallax({super.key, required this.child, this.depth = 80});
  final Widget child;
  final double depth;
  @override
  Widget build(BuildContext c) =>
      Transform.translate(offset: Offset(0, SceneT.of(c) * depth), child: child);
}

/// Staggered entrance: fade + slide + scale, or a masked "rise" for headlines.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.delay = 0,
    this.dx = 0,
    this.dy = 40,
    this.scale = 1,
    this.clip = false,
  });
  final Widget child;
  final int delay; // ms
  final double dx, dy, scale;
  final bool clip; // true = text rises from behind a mask
  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  static const _total = 1700;
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: _total));
  bool _played = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_played && SceneT.of(context).abs() < .35) {
      _played = true;
      _c.forward();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = (widget.delay / _total).clamp(0.0, 1.0).toDouble();
    final e = ((widget.delay + 950) / _total).clamp(0.0, 1.0).toDouble();
    final curve = Interval(b, e, curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (_, child) {
        final v = curve.transform(_c.value);
        if (widget.clip) {
          return ClipRect(
            child: FractionalTranslation(
              translation: Offset(0, 1.1 * (1 - v)),
              child: Opacity(opacity: c01(v * 2), child: child),
            ),
          );
        }
        return Opacity(
          opacity: c01(v * 1.4),
          child: Transform.translate(
            offset: Offset(widget.dx * (1 - v), widget.dy * (1 - v)),
            child: Transform.scale(
                scale: widget.scale + (1 - widget.scale) * v, child: child),
          ),
        );
      },
    );
  }
}

// ───────────────────────── 3D widgets ─────────────────────────

/// Hover tilt in real 3D perspective, with a moving light glare.
/// Wrap any card / photo in this and it leans toward the cursor.
class Tilt3D extends StatefulWidget {
  const Tilt3D({
    super.key,
    required this.child,
    this.radius = 18,
    this.max = .16, // max tilt in radians
    this.lift = 1.035, // scale-up while hovered
  });
  final Widget child;
  final double radius, max, lift;
  @override
  State<Tilt3D> createState() => _Tilt3DState();
}

class _Tilt3DState extends State<Tilt3D> {
  Offset _o = Offset.zero; // -1..1 inside the widget
  bool _in = false;

  void _hover(PointerEvent e) {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    final sz = box.size;
    if (sz.width < 1 || sz.height < 1) return;
    setState(() {
      _in = true;
      _o = Offset(
        ((e.localPosition.dx / sz.width) * 2 - 1).clamp(-1.0, 1.0).toDouble(),
        ((e.localPosition.dy / sz.height) * 2 - 1).clamp(-1.0, 1.0).toDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _hover,
      onExit: (_) => setState(() {
        _in = false;
        _o = Offset.zero;
      }),
      child: AnimatedScale(
        scale: _in ? widget.lift : 1,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: _o),
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          child: widget.child,
          builder: (_, o, child) {
            final m = Matrix4.identity()
              ..setEntry(3, 2, .0014)
              ..rotateX(-o.dy * widget.max)
              ..rotateY(o.dx * widget.max);
            final glare = c01(o.distance * 1.2) * .16;
            return Transform(
              alignment: Alignment.center,
              transform: m,
              child: Stack(
                fit: StackFit.passthrough,
                clipBehavior: Clip.none,
                children: [
                  child!,
                  Positioned.fill(
                    child: IgnorePointer(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(widget.radius),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment(o.dx, o.dy),
                              radius: .9,
                              colors: [
                                Colors.white.withOpacity(glare),
                                Colors.transparent
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Big headline with a stacked "extruded" 3D depth. The extrusion direction
/// follows the mouse, like a light source moving around the letters.
class Extruded extends StatelessWidget {
  const Extruded(
    this.text,
    this.style, {
    super.key,
    this.depth = 9,
    this.color = const Color(0xFF8A2A12),
  });
  final String text;
  final TextStyle style;
  final int depth;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: gMouse,
      builder: (_, m, __) {
        final dir = Offset(1.1 - m.dx * 1.6, 1.3 - m.dy * 1.2);
        return Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = depth; i >= 1; i--)
              Transform.translate(
                offset: dir * (i * 1.6),
                child: Text(
                  text,
                  style: style.copyWith(
                      color: Color.lerp(color, Colors.black, i / depth)),
                ),
              ),
            Text(text, style: style),
          ],
        );
      },
    );
  }
}

// ───────────────────────── app ─────────────────────────

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ajilesh V — Flutter Developer',
        theme: ThemeData.dark(useMaterial3: true)
            .copyWith(scaffoldBackgroundColor: kBg),
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  static const n = 6;
  static const names = ['Home', 'About', 'Skills', 'Journey', 'Projects', 'Contact'];

  final _p = ValueNotifier<double>(0);
  final _focus = FocusNode();
  double _target = 0, _cur = 0;
  Offset _mTarget = Offset.zero;
  Duration _last = Duration.zero;
  Timer? _snap;
  late final Ticker _tick;

  @override
  void initState() {
    super.initState();
    _tick = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _tick.dispose();
    _snap?.cancel();
    _focus.dispose();
    super.dispose();
  }

  void _onTick(Duration d) {
    final dt = ((d - _last).inMicroseconds / 1e6).clamp(0.0, .05).toDouble();
    _last = d;

    // smooth the mouse so every 3D effect glides instead of jittering
    final m = gMouse.value;
    final nm = Offset.lerp(m, _mTarget, 1 - math.exp(-dt * 5))!;
    if ((nm - m).distance > .0004) gMouse.value = nm;

    if (_cur == _target) return;
    _cur += (_target - _cur) * (1 - math.exp(-dt * 6));
    if ((_target - _cur).abs() < .0008) _cur = _target;
    _p.value = _cur;
  }

  void _setMouse(Offset p, Size s) {
    if (s.width < 1 || s.height < 1) return;
    _mTarget = Offset(
      ((p.dx / s.width) * 2 - 1).clamp(-1.0, 1.0).toDouble(),
      ((p.dy / s.height) * 2 - 1).clamp(-1.0, 1.0).toDouble(),
    );
  }

  // Wheel / drag nudges the target; after a short pause it snaps to a scene.
  void _nudge(double dx) {
    _target = (_target + dx).clamp(0.0, n - 1.0).toDouble();
    _snap?.cancel();
    _snap = Timer(const Duration(milliseconds: 160),
        () => _target = _target.roundToDouble());
  }

  void _go(int i) {
    _snap?.cancel();
    _target = i.clamp(0, n - 1).toDouble();
  }

  // Scenes "dwell" at integers; the zoom transition happens in the middle.
  double _dwell(double x) {
    final i = x.floor();
    final f = x - i;
    final s = c01((f - .28) / .44);
    return i + s * s * (3 - 2 * s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Focus(
        focusNode: _focus,
        autofocus: true,
        onKeyEvent: (_, e) {
          if (e is KeyDownEvent) {
            final k = e.logicalKey;
            final r = _target.round();
            if (k == LogicalKeyboardKey.arrowDown ||
                k == LogicalKeyboardKey.pageDown ||
                k == LogicalKeyboardKey.space) {
              _go(r + 1);
              return KeyEventResult.handled;
            }
            if (k == LogicalKeyboardKey.arrowUp ||
                k == LogicalKeyboardKey.pageUp) {
              _go(r - 1);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: LayoutBuilder(builder: (context, box) {
          final s = box.biggest;
          final scenes = List<Widget>.generate(n, (i) => _scene(i, s));
          return Listener(
            onPointerSignal: (e) {
              if (e is PointerScrollEvent) _nudge(e.scrollDelta.dy / 900);
            },
            onPointerHover: (e) => _setMouse(e.localPosition, s),
            onPointerMove: (e) => _setMouse(e.localPosition, s),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onVerticalDragUpdate: (d) => _nudge(-d.delta.dy / s.height * 1.1),
              child: ValueListenableBuilder<double>(
                valueListenable: _p,
                builder: (_, x, __) => _stage(x, s, scenes),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _stage(double raw, Size s, List<Widget> scenes) {
    final p = _dwell(raw);
    final f = p - p.floor();
    final flash = math.sin(f * math.pi);
    return Stack(children: [
      const SizedBox.expand(child: ColoredBox(color: kBg)),
      // parallax sky: real building images + helicopter (falls back to drawn)
      Positioned.fill(child: RepaintBoundary(child: CodeSky(progress: _p))),
      for (var i = 0; i < n; i++)
        if ((p - i).abs() < 1)
          // Key per scene so each scene keeps its own Reveal state and
          // replays its entrance every time it comes back.
          KeyedSubtree(key: ValueKey('scene$i'), child: _fx(scenes[i], p - i)),
      // cinematic light-leak flash between scenes
      IgnorePointer(
        child: Opacity(
          opacity: flash * flash * .16,
          child: const SizedBox.expand(child: ColoredBox(color: Colors.white)),
        ),
      ),
      // vignette
      const IgnorePointer(
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 1.2,
                colors: [Colors.transparent, Color(0x99000000)],
              ),
            ),
          ),
        ),
      ),
      _nav(p),
    ]);
  }

  // The 3D "zoom-through" transition: the outgoing scene swings and rushes
  // toward the camera with motion blur, the next one flies in from the
  // distance. (Mouse 3D lives only in the texts and widgets, not here.)
  Widget _fx(Widget child, double t) {
    double scale, blur, op;
    if (t >= 0) {
      scale = 1 + 2.4 * Curves.easeInCubic.transform(t);
      blur = 26 * t;
      op = c01(1 - t * 1.3);
    } else {
      final e = 1 + t;
      scale = .62 + .38 * Curves.easeOutCubic.transform(e);
      blur = 26 * (1 - e);
      op = c01(e * 1.3);
    }
    Widget w = SceneT(t: t, child: child);
    if (blur > .6) {
      w = ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: w);
    }
    final mat = Matrix4.identity()
      ..setEntry(3, 2, .0005)
      ..rotateX(t * .12)
      ..rotateY(t * .35)
      ..scale(scale, scale, 1.0);
    w = Transform(alignment: Alignment.center, transform: mat, child: w);
    return IgnorePointer(
        ignoring: t.abs() > .3, child: Opacity(opacity: op, child: w));
  }

  Widget _nav(double p) {
    final cur = p.round().clamp(0, n - 1);
    return Stack(children: [
      Positioned(
        left: 28,
        top: 20,
        child: GestureDetector(
            onTap: () => _go(0),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text('AJILESH V.', style: disp(28)))),
      ),
      Positioned(
        right: 56,
        top: 26,
        child: Text(
            '${(cur + 1).toString().padLeft(2, '0')} / 0$n  ·  ${names[cur].toUpperCase()}',
            style: body(12, c: Colors.white60, w: FontWeight.w600, ls: 2)),
      ),
      Positioned(
        right: 10,
        top: 0,
        bottom: 0,
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < n; i++)
              GestureDetector(
                onTap: () => _go(i),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Tooltip(
                    message: names[i],
                    child: Padding(
                      padding: const EdgeInsets.all(7),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 7,
                        height: cur == i ? 26 : 7,
                        decoration: BoxDecoration(
                          color: cur == i ? kAcc : Colors.white38,
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ]),
        ),
      ),
      Positioned(
        bottom: 22,
        left: 0,
        right: 0,
        child: IgnorePointer(
          child: Opacity(
            opacity: c01(1 - p * 3),
            child: Column(children: [
              Text('SCROLL', style: body(11, c: Colors.white70, ls: 5)),
              const Icon(Icons.keyboard_arrow_down, color: kAcc),
            ]),
          ),
        ),
      ),
    ]);
  }

  // ───────────────────────── helpers ─────────────────────────
  Widget _frame(Size s, Widget child) {
    final w = (s.width * .86).clamp(300.0, 1200.0).toDouble();
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 76, 0, 44),
        child: FittedBox(
            fit: BoxFit.scaleDown, child: SizedBox(width: w, child: child)),
      ),
    );
  }

  // Background image with parallax drift (scaled up so edges never show).
  // `opacity` < 1 lets the sky + helicopter show through the photo.
  // If the asset is missing it simply draws nothing.
  Widget _bg(String asset, Alignment al,
          {bool leftFade = true, double opacity = 1}) =>
      Positioned.fill(
        child: Stack(fit: StackFit.expand, children: [
          ClipRect(
            child: Transform.scale(
              scale: 1.2,
              child: Parallax(
                depth: 90,
                child: Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    asset,
                    fit: BoxFit.cover,
                    alignment: al,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: leftFade ? Alignment.centerLeft : Alignment.topCenter,
                end: leftFade ? Alignment.centerRight : Alignment.bottomCenter,
                colors: const [Color(0xF00A0A0C), Color(0xA00A0A0C), Color(0x330A0A0C)],
              ),
            ),
          ),
        ]),
      );

  Widget _glow() => const Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(.6, -.2),
              radius: .9,
              colors: [Color(0x33FF5A36), Colors.transparent],
            ),
          ),
        ),
      );

  Widget _head(String kicker, String title, bool wide) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Reveal(
              dy: 20,
              child: Text(kicker.toUpperCase(),
                  style: body(13, c: kAcc, w: FontWeight.w700, ls: 4))),
          const SizedBox(height: 6),
          Reveal(
              delay: 90,
              dy: 40,
              child: Extruded(title, disp(wide ? 92 : 54), depth: wide ? 7 : 5)),
          const SizedBox(height: 18),
        ],
      );

  // Chip that tilts in 3D on hover.
  Widget _chip(String t) => Tilt3D(
        radius: 99,
        max: .30,
        lift: 1.08,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0x1AFFFFFF),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: const Color(0x26FFFFFF)),
          ),
          child: Text(t, style: body(13, c: Colors.white)),
        ),
      );

  // Glass card that leans toward the mouse in 3D.
  Widget _card(Widget c, {double? w, int d = 0}) => Reveal(
        delay: d,
        dy: 60,
        scale: .94,
        child: Tilt3D(
          radius: 18,
          max: .12,
          child: Container(
            width: w,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0x14FFFFFF),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x1FFFFFFF)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x55000000), blurRadius: 30, offset: Offset(0, 14))
              ],
            ),
            child: c,
          ),
        ),
      );

  Widget _btn(String l, String url, {bool filled = false}) {
    const pad = EdgeInsets.symmetric(horizontal: 20, vertical: 15);
    final b = filled
        ? FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: kAcc, foregroundColor: Colors.white, padding: pad),
            onPressed: () => open(url),
            child: Text(l))
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white38),
                padding: pad),
            onPressed: () => open(url),
            child: Text(l));
    // buttons lean toward the cursor in 3D
    return Tilt3D(radius: 40, max: .25, lift: 1.06, child: b);
  }

  // Photo with 3D hover tilt + glare.
  Widget _photo(String a, double ratio, Alignment al) => Tilt3D(
        radius: 26,
        max: .10,
        lift: 1.04,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: const [
              BoxShadow(color: Color(0x40FF5A36), blurRadius: 80, spreadRadius: -10)
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: AspectRatio(
              aspectRatio: ratio,
              child: Image.asset(a, fit: BoxFit.cover, alignment: al),
            ),
          ),
        ),
      );

  Widget _item(String t, String o, String d) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t, style: body(16, c: Colors.white, w: FontWeight.w600)),
          Text(o, style: body(14)),
          Text(d, style: body(12.5, c: kAcc, w: FontWeight.w600)),
        ]),
      );

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(t.toUpperCase(),
            style: body(12, c: kAcc, w: FontWeight.w700, ls: 3)),
      );

  // ───────────────────────── scenes ─────────────────────────
  Widget _scene(int i, Size s) {
    final wide = s.width > 900;
    switch (i) {
      case 0:
        return _hero(s, wide);
      case 1:
        return _about(s, wide);
      case 2:
        return _skills(s, wide);
      case 3:
        return _journey(s, wide);
      case 4:
        return _projects(s, wide);
      default:
        return _contact(s, wide);
    }
  }

  Widget _hero(Size s, bool wide) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Reveal(
            clip: true,
            child: Text('HELLO, I’M',
                style: body(14, c: kAcc, w: FontWeight.w700, ls: 5))),
        // 3D extruded name: depth follows the mouse
        Reveal(
            delay: 120,
            dy: 60,
            child: Extruded('AJILESH V', disp(wide ? 170 : 84),
                depth: wide ? 10 : 6)),
        Reveal(
            delay: 260,
            clip: true,
            child: Text('Flutter Developer', style: disp(wide ? 56 : 34, c: kAcc))),
        Reveal(
            delay: 360,
            clip: true,
            child: Text('& Cyber Security Researcher',
                style: disp(wide ? 40 : 24))),
        const SizedBox(height: 18),
        Reveal(
          delay: 520,
          child: Text(
            'I build fast, polished Flutter apps — from Firebase-backed marketplaces to offline-first tools — with a security researcher’s eye for how things break.',
            style: body(wide ? 17 : 15),
          ),
        ),
        const SizedBox(height: 26),
        Reveal(
          delay: 650,
          child: Wrap(spacing: 12, runSpacing: 12, children: [
            _btn('GitHub', 'https://github.com/Aji46', filled: true),
            _btn('LinkedIn', 'https://www.linkedin.com/in/ajilesh-v-/'),
            _btn('LeetCode', 'https://leetcode.com/u/Aji46/'),
          ]),
        ),
      ],
    );
    final photo = Reveal(
      delay: 250,
      dx: 140,
      dy: 0,
      scale: .9,
      child: Parallax(
          depth: 70, child: _photo(Pics.portrait, .78, Alignment.topCenter)),
    );
    return Stack(fit: StackFit.expand, children: [
      // full-screen first image (assets/images/hero_bg.jpg)
      _bg(Pics.heroBg, Alignment.center, opacity: .55),
      _glow(),
      _frame(
        s,
        wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(flex: 6, child: text),
                const SizedBox(width: 48),
                Expanded(flex: 4, child: photo),
              ])
            : Column(mainAxisSize: MainAxisSize.min, children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 230), child: photo),
                const SizedBox(height: 22),
                text,
              ]),
      ),
    ]);
  }

  Widget _about(Size s, bool wide) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _head('Who I am', 'About me', wide),
        Reveal(
          delay: 200,
          child: Text(
            'Passionate and dedicated Flutter mobile app developer specializing in creating efficient, user-friendly applications. Proficient in Dart and well-versed in UI/UX design principles, with a commitment to staying ahead in the rapidly evolving mobile landscape. I aim to deliver impactful solutions that exceed expectations through innovation and collaboration.',
            style: body(wide ? 17 : 15),
          ),
        ),
        const SizedBox(height: 22),
        Reveal(
          delay: 380,
          child: Wrap(spacing: 10, runSpacing: 10, children: [
            _chip('Certified Ethical Hacker'),
            _chip('Certified Penetration Tester'),
            _chip('2 apps on Amazon Appstore'),
            _chip('Brototype · Flutter 2023–24'),
          ]),
        ),
      ],
    );
    return Stack(fit: StackFit.expand, children: [
      // semi-transparent photo so the sky + helicopter stay visible
      _bg('assets/images/wa7.jpeg', const Alignment(.8, 0), opacity: .4),
      _frame(
        s,
        wide
            ? Row(children: [
                Expanded(flex: 5, child: text),
                const Spacer(flex: 5),
              ])
            : text,
      ),
    ]);
  }

  Widget _skillCard(String t, List<String> items, int d) => _card(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label(t),
          Wrap(spacing: 8, runSpacing: 8, children: items.map(_chip).toList()),
        ]),
        w: 270,
        d: d,
      );

  Widget _skills(Size s, bool wide) {
    final data = <String, List<String>>{
      'Language': ['Dart'],
      'Framework': ['Flutter'],
      'State management': ['Bloc', 'GetX', 'Provider'],
      'Databases': ['Hive', 'Firebase', 'sqflite'],
      'Tools': ['Git', 'GitHub', 'Figma'],
      'Deployment': ['Amazon App Store'],
      'Proficient in': ['Data Structures', 'Third-party Integrations', 'REST APIs'],
      'Familiar with': [
        'JavaScript',
        'C',
        'HTML',
        'CSS',
        'MVC Architecture',
        'Code Optimization'
      ],
    }.entries.toList();

    final grid = Wrap(spacing: 16, runSpacing: 16, children: [
      for (var i = 0; i < data.length; i++)
        _skillCard(data[i].key, data[i].value, 200 + i * 90),
    ]);

    // Bottom-crop the photo so the baked-in "Black & white" caption is hidden.
    final photo = Reveal(
      delay: 400,
      dx: 120,
      dy: 0,
      scale: .92,
      child: Parallax(
          depth: 60,
          child: _photo('assets/images/wa8.jpeg', 1.2, Alignment.topCenter)),
    );
    return Stack(fit: StackFit.expand, children: [
      _glow(),
      _frame(
        s,
        wide
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _head('What I use', 'Skills & stack', wide),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(flex: 6, child: grid),
                      const SizedBox(width: 32),
                      Expanded(flex: 4, child: photo),
                    ]),
                  ])
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _head('What I use', 'Skills & stack', wide),
                    grid,
                  ]),
      ),
    ]);
  }

  Widget _journey(Size s, bool wide) {
    final exp = _card(
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Experience'),
        _item('Flutter Developer', 'Softroniics', 'May 8, 2026 – Present'),
        _item('Junior Software Consultant – R&D', 'Datamate Info Solution Limited',
            'Mar 17, 2025 – Oct 31, 2025'),
        const SizedBox(height: 6),
        _label('Certifications'),
        _item('Certified Penetration Tester',
            'RedTeam Hacker Academy, Perinthalmanna', 'Jun 13 – Aug 20, 2022'),
        _item('Certified Ethical Hacker',
            'EC-Council (RedTeam Hacker Academy) · ECC5876913240',
            'Nov 22 – Dec 23, 2022'),
      ]),
      d: 200,
    );
    final edu = _card(
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _label('Education'),
        _item('Mobile App Development Using Flutter', 'Brototype, Calicut',
            '2023 – 2024'),
        _item('Bachelor of Computer Application',
            'GEMS Arts and Science College, Perinthalmanna', '2019 – 2022'),
        _item('Computer Science & Information Technology',
            'S H M G VHSS, Edavanna', '2017 – 2019'),
        _item('S S L C', 'V M C G H S S, Wandoor', '2017'),
      ]),
      d: 380,
    );
    return Stack(fit: StackFit.expand, children: [
      _glow(),
      _frame(
        s,
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _head('My path', 'Journey', wide),
              wide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: exp),
                      const SizedBox(width: 20),
                      Expanded(child: edu),
                    ])
                  : Column(children: [exp, const SizedBox(height: 16), edu]),
            ]),
      ),
    ]);
  }

  Widget _proj(String t, String d, List<String> tags, Map<String, String> links,
          int delay) =>
      _card(
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Extruded(t, disp(40), depth: 4),
          const SizedBox(height: 8),
          Text(d, style: body(14)),
          const SizedBox(height: 14),
          Wrap(spacing: 8, runSpacing: 8, children: tags.map(_chip).toList()),
          const SizedBox(height: 18),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final e in links.entries)
              _btn(e.key, e.value, filled: e.key.startsWith('Live')),
          ]),
        ]),
        d: delay,
      );

  Widget _projects(Size s, bool wide) {
    final cards = [
      _proj(
        'QUOKART',
        'Used-product marketplace connecting users with deals and offers. Multi-method login (email, phone, Google), category browsing, location-based deals, and an admin panel for categories and products. MVC architecture with Provider.',
        ['Flutter', 'Firebase', 'Provider', 'MVC'],
        {
          'Live (Amazon)':
              'https://www.amazon.in/Brototype-Quokart/dp/B0DKNRMM8C/',
          'User app': 'https://github.com/Aji46/Quick_deals_User_side',
          'Admin app': 'https://github.com/Aji46/Quick-O-Deals-Admin',
        },
        200,
      ),
      _proj(
        'DROPBLOOD',
        'Blood donation app connecting donors and recipients with real-time updates, Firebase authentication, secure data handling, and Hive for offline access.',
        ['Flutter', 'Firebase', 'Hive'],
        {
          'Live (Amazon)': 'https://www.amazon.in/dp/B0DPTG9PWM/',
          'GitHub': 'https://github.com/Aji46/Reddrop_new',
        },
        380,
      ),
      _proj(
        'MINI PROJECTS',
        'Student Management app in GetX and Provider + Hive versions, and a Netflix clone built with Flutter and the TMDB API with responsive UI and movie search.',
        ['GetX', 'Provider', 'Hive', 'TMDB API'],
        {
          'Student · GetX': 'https://github.com/Aji46/student_app_getx',
          'Student · Provider': 'https://github.com/Aji46/student-app-provider',
          'Netflix clone': 'https://github.com/Aji46/Netflix_clone',
        },
        560,
      ),
    ];
    return Stack(fit: StackFit.expand, children: [
      _glow(),
      _frame(
        s,
        Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _head('Selected work', 'Projects', wide),
              wide
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      for (var i = 0; i < cards.length; i++) ...[
                        if (i > 0) const SizedBox(width: 18),
                        Expanded(child: cards[i]),
                      ]
                    ])
                  : Column(children: [
                      for (final c in cards) ...[c, const SizedBox(height: 14)]
                    ]),
            ]),
      ),
    ]);
  }

  Widget _contact(Size s, bool wide) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Reveal(
            dy: 20,
            child: Text('LET’S WORK TOGETHER',
                style: body(13, c: kAcc, w: FontWeight.w700, ls: 4))),
        const SizedBox(height: 6),
        Reveal(
            delay: 100,
            clip: true,
            child: Text('READY TO TAKE', style: disp(wide ? 110 : 56))),
        // 3D extruded accent headline
        Reveal(
            delay: 220,
            dy: 50,
            child: Extruded('THE LEAP?', disp(wide ? 110 : 56, c: kAcc),
                depth: wide ? 9 : 6, color: const Color(0xFF5A1808))),
        const SizedBox(height: 18),
        Reveal(
            delay: 400,
            child: Text(
                'Have an app idea, a product to ship, or a security question? Let’s talk.',
                style: body(wide ? 17 : 15))),
        const SizedBox(height: 24),
        Reveal(
          delay: 540,
          child: Wrap(spacing: 12, runSpacing: 12, children: [
            _btn('ajilesh46@gmail.com', 'mailto:ajilesh46@gmail.com', filled: true),
            _btn('+91 89433 81295', 'tel:+918943381295'),
            _btn('LinkedIn', 'https://www.linkedin.com/in/ajilesh-v-/'),
            _btn('GitHub', 'https://github.com/Aji46'),
            _btn('Brototype portfolio',
                'https://v2-app.brototype.com/portfolio?id=08f04504-2607-4569-b40a-814b4c5a33d5'),
          ]),
        ),
      ],
    );
    final photo = Reveal(
      delay: 150,
      dx: -140,
      dy: 0,
      scale: .9,
      child: Parallax(
          depth: 60,
          child: _photo('assets/images/leap.jpg', .75, Alignment.center)),
    );
    return Stack(fit: StackFit.expand, children: [
      _glow(),
      _frame(
        s,
        wide
            ? Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(flex: 4, child: photo),
                const SizedBox(width: 48),
                Expanded(flex: 6, child: text),
              ])
            : Column(mainAxisSize: MainAxisSize.min, children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 200), child: photo),
                const SizedBox(height: 20),
                text,
              ]),
      ),
    ]);
  }
}

// ───────────────────────── sky: real images + helicopter ─────────────────────────

class _SkyData {
  double p = 0, t = 0, rot = 0, vel = 0, dir = 1;
  // loaded image assets (null = use the code-drawn fallback)
  ui.Image? far, mid, near, heli, rotor;
}

class _Token {
  _Token(this.tp, this.nx, this.ny, this.depth);
  final TextPainter tp;
  final double nx, ny, depth;
}

class CodeSky extends StatefulWidget {
  const CodeSky({super.key, required this.progress});
  final ValueListenable<double> progress;
  @override
  State<CodeSky> createState() => _CodeSkyState();
}

class _CodeSkyState extends State<CodeSky> with SingleTickerProviderStateMixin {
  final _d = _SkyData();
  final _time = ValueNotifier<double>(0);
  late final Ticker _tk;
  late final List<_Token> _tokens;
  Duration _last = Duration.zero;
  double _lastP = 0;

  @override
  void initState() {
    super.initState();
    _loadImages();
    const words = [
      'async / await',
      'Widget build()',
      'setState(() {})',
      'flutter run',
      'git push',
      '</>',
      '=>',
      '{ }',
      'final x = 42;',
      'Future<void>',
      'BlocProvider',
      'class App extends',
      '0xFF5A36',
      'return Scaffold(',
      'pub get',
      'if (secure)',
      'nmap -sV',
      'sudo ./exploit',
    ];
    final r = math.Random(11);
    _tokens = List.generate(26, (i) {
      final depth = .25 + r.nextDouble() * .75;
      final tp = TextPainter(
        text: TextSpan(
          text: words[i % words.length],
          style: GoogleFonts.jetBrainsMono(
            fontSize: 11 + depth * 7,
            color: (i % 5 == 0 ? kAcc : Colors.white)
                .withOpacity(.05 + depth * .13),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      return _Token(tp, r.nextDouble(), .05 + r.nextDouble() * .6, depth);
    });
    _tk = createTicker((d) {
      final dt = ((d - _last).inMicroseconds / 1e6).clamp(0.001, .05).toDouble();
      _last = d;
      final p = widget.progress.value;
      final v = (p - _lastP) / dt;
      _lastP = p;
      _d.vel += (v - _d.vel) * math.min(1.0, dt * 8);
      if (_d.vel > .08) _d.dir = 1;
      if (_d.vel < -.08) _d.dir = -1;
      _d.rot += dt * (16 + _d.vel.abs() * 14);
      _d.p = p;
      _d.t = d.inMicroseconds / 1e6;
      _time.value = _d.t; // triggers repaint every frame
    })
      ..start();
  }

  Future<void> _loadImages() async {
    _d.far = await loadUiImage(Pics.cityFar);
    _d.mid = await loadUiImage(Pics.cityMid);
    _d.near = await loadUiImage(Pics.cityNear);
    _d.heli = await loadUiImage(Pics.heliBody);
    _d.rotor = await loadUiImage(Pics.heliRotor);
  }

  @override
  void dispose() {
    _tk.dispose();
    _time.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomPaint(
        painter: _SkyPainter(_d, _tokens, _time),
        size: Size.infinite,
      );
}

class _SkyPainter extends CustomPainter {
  _SkyPainter(this.d, this.tokens, Listenable repaint) : super(repaint: repaint);
  final _SkyData d;
  final List<_Token> tokens;

  @override
  void paint(Canvas canvas, Size s) {
    final w = s.width, h = s.height;

    // sky gradient + horizon glow
    canvas.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0A0C), Color(0xFF160D12), Color(0xFF2A1210)],
          stops: [0, .6, 1],
        ).createShader(Offset.zero & s),
    );
    final glowC = Offset(w * (.3 + .4 * (d.p / 5)), h * .95);
    canvas.drawCircle(
      glowC,
      w * .45,
      Paint()
        ..shader = RadialGradient(
          colors: [kAcc.withOpacity(.22), Colors.transparent],
        ).createShader(Rect.fromCircle(center: glowC, radius: w * .45)),
    );

    // floating code tokens (parallax by depth)
    for (final k in tokens) {
      final span = w + k.tp.width + 80;
      var x = (k.nx * span - d.p * k.depth * w * .55) % span;
      if (x < 0) x += span;
      final y = h * k.ny + math.sin(d.t * .6 + k.nx * 9) * 10 * k.depth;
      k.tp.paint(canvas, Offset(x - k.tp.width, y));
    }

    // far buildings
    if (d.far != null) {
      _imgLayer(canvas, s, d.far!, speed: .10, heightFrac: .50, opacity: .75);
    } else {
      _skyline(canvas, s,
          seed: 1,
          speed: .10,
          minH: .16,
          maxH: .38,
          color: const Color(0xFF12131A),
          windows: false);
    }

    // middle buildings
    if (d.mid != null) {
      _imgLayer(canvas, s, d.mid!, speed: .26, heightFrac: .42, opacity: .9);
    } else {
      _skyline(canvas, s,
          seed: 2,
          speed: .26,
          minH: .12,
          maxH: .30,
          color: const Color(0xFF181A23),
          windows: true);
    }

    _helicopter(canvas, s);

    // near buildings (in front of the helicopter)
    if (d.near != null) {
      _imgLayer(canvas, s, d.near!, speed: .55, heightFrac: .26);
    } else {
      _skyline(canvas, s,
          seed: 3,
          speed: .55,
          minH: .05,
          maxH: .16,
          color: const Color(0xFF0D0E13),
          windows: false,
          minW: 70,
          maxW: 140);
    }
  }

  /// Tiles a real building image across the screen, bottom-aligned, scrolling
  /// at [speed]. Alternate tiles are mirrored so the loop never shows a seam.
  void _imgLayer(Canvas canvas, Size s, ui.Image img,
      {required double speed,
      required double heightFrac,
      double opacity = 1}) {
    final h = s.height * heightFrac;
    final scale = h / img.height;
    final tw = img.width * scale;
    if (tw < 4) return;
    final shift = d.p * speed * s.width;
    final first = (shift / tw).floor();
    final src = Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble());
    final paint = Paint()
      ..filterQuality = FilterQuality.medium
      ..color = Colors.white.withOpacity(opacity);
    // start one tile early / end one tile late so mouse parallax never
    // exposes an empty edge
    for (var k = first - 1; k * tw - shift < s.width + 100; k++) {
      final x = k * tw - shift;
      final dst = Rect.fromLTWH(0, s.height - h, tw + 1, h);
      canvas.save();
      if (k.isOdd) {
        canvas.translate(x + tw, 0);
        canvas.scale(-1, 1);
      } else {
        canvas.translate(x, 0);
      }
      canvas.drawImageRect(img, src, dst, paint);
      canvas.restore();
    }
  }

  // Fallback: code-drawn skyline when no building image is provided.
  void _skyline(Canvas canvas, Size s,
      {required int seed,
      required double speed,
      required double minH,
      required double maxH,
      required Color color,
      required bool windows,
      double minW = 40,
      double maxW = 95}) {
    final r = math.Random(seed);
    final paint = Paint()..color = color;
    final off = d.p * speed * s.width;
    final limit = s.width * (1 + 5 * speed) + 320;
    var x = -120.0;
    var idx = 0;
    while (x < limit) {
      final bw = minW + r.nextDouble() * (maxW - minW);
      final bh = s.height * (minH + r.nextDouble() * (maxH - minH));
      final bx = x - off;
      if (bx + bw > -100 && bx < s.width + 100) {
        final rect = Rect.fromLTWH(bx, s.height - bh, bw, bh);
        canvas.drawRect(rect, paint);
        if (windows) {
          var row = 0;
          for (var y = rect.top + 10; y < rect.bottom - 8; y += 14, row++) {
            var col = 0;
            for (var wx = bx + 7; wx < bx + bw - 7; wx += 12, col++) {
              final hsh = ((idx * 73856093) ^ (row * 19349663) ^ (col * 83492791))
                      .abs() %
                  100;
              if (hsh < 16) {
                var a = .55;
                if (hsh % 7 == 0) a = .25 + .3 * (math.sin(d.t * 3 + hsh) + 1) / 2;
                canvas.drawRect(
                  Rect.fromLTWH(wx, y, 4, 6),
                  Paint()
                    ..color = (hsh < 3 ? kAcc : const Color(0xFFFFE2B0))
                        .withOpacity(a),
                );
              }
            }
          }
        }
      }
      x += bw + 4 + r.nextDouble() * 8;
      idx++;
    }
  }

  void _helicopter(Canvas canvas, Size s) {
    final w = s.width, h = s.height;
    final prog = (d.p / 5).clamp(0.0, 1.0).toDouble();
    final x = w * (.12 + .76 * prog);
    final y = h * .24 + math.sin(d.p * 1.7) * h * .07 + math.sin(d.t * 2.2) * 5;
    final k = (s.shortestSide / 520).clamp(.7, 1.6).toDouble();
    final tilt = (d.vel * .08).clamp(-.22, .22).toDouble() * d.dir + .05;

    canvas.save();
    canvas.translate(x, y);
    canvas.scale(k * d.dir, k);
    canvas.rotate(tilt);

    if (d.heli != null) {
      _imageHeli(canvas, h / k);
    } else {
      _paintedHeli(canvas, h / k);
    }

    canvas.restore();
  }

  void _beam(Canvas canvas, Offset from, double floorY) {
    final beam = Path()
      ..moveTo(from.dx, from.dy)
      ..lineTo(from.dx + 230, floorY)
      ..lineTo(from.dx + 30, floorY)
      ..close();
    canvas.drawPath(
      beam,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kAcc.withOpacity(.22), Colors.transparent],
        ).createShader(
            Rect.fromLTWH(from.dx, from.dy, 230, floorY - from.dy)),
    );
  }

  // Real helicopter picture + animated rotor.
  void _imageHeli(Canvas canvas, double floorY) {
    final img = d.heli!;
    const hw = 300.0; // helicopter width in local units
    final hh = hw * img.height / img.width;
    final body = Rect.fromCenter(center: Offset.zero, width: hw, height: hh);

    _beam(canvas, Offset(hw * .22, hh * .30), floorY * .8);

    // soft glow so a dark picture reads against the sky
    canvas.drawOval(
        Rect.fromCenter(center: Offset(0, hh * .05), width: hw * .9, height: hh * .9),
        Paint()
          ..color = kAcc.withOpacity(.07)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30));

    canvas.drawImageRect(
      img,
      Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
      body,
      Paint()..filterQuality = FilterQuality.medium,
    );

    // rotor position on the image
    final anchor = Offset(
      body.left + body.width * Pics.rotorAnchor.dx,
      body.top + body.height * Pics.rotorAnchor.dy,
    );

    if (d.rotor != null) {
      // Spinning rotor: squash horizontally + flicker, like blades passing.
      final r = d.rotor!;
      final rw = hw * Pics.rotorWidthFrac;
      final rh = rw * r.height / r.width;
      final c = math.cos(d.rot).abs();
      canvas.save();
      canvas.translate(anchor.dx, anchor.dy);
      canvas.scale(.55 + .45 * c, 1);
      canvas.drawImageRect(
        r,
        Rect.fromLTWH(0, 0, r.width.toDouble(), r.height.toDouble()),
        Rect.fromCenter(center: Offset.zero, width: rw, height: rh),
        Paint()
          ..filterQuality = FilterQuality.medium
          ..color = Colors.white.withOpacity(.55 + .4 * c),
      );
      canvas.restore();
    } else {
      // No rotor image: draw a spinning blade over the picture.
      canvas.drawOval(
          Rect.fromCenter(center: anchor, width: hw * .95, height: 6),
          Paint()..color = Colors.white.withOpacity(.10));
      final bl = hw * .47 * math.cos(d.rot);
      canvas.drawLine(
          Offset(anchor.dx - bl, anchor.dy),
          Offset(anchor.dx + bl, anchor.dy),
          Paint()
            ..color = Colors.white54
            ..strokeWidth = 2.5
            ..strokeCap = StrokeCap.round);
    }

    // blinking nav light at the tail
    final on = (math.sin(d.t * 6) > 0);
    if (on) {
      canvas.drawCircle(
          Offset(body.left + body.width * .03, body.top + body.height * .30),
          2.8,
          Paint()..color = Colors.redAccent);
    }
  }

  // Fallback: code-drawn helicopter.
  void _paintedHeli(Canvas canvas, double floorY) {
    _beam(canvas, const Offset(30, 16), floorY * .8);

    final body = Paint()..color = const Color(0xFF1D2028);
    final line = Paint()
      ..color = const Color(0xFF2B2F3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // tail boom + fin
    canvas.drawPath(
        Path()
          ..moveTo(-26, -6)
          ..lineTo(-100, -12)
          ..lineTo(-100, -4)
          ..lineTo(-26, 8)
          ..close(),
        body);
    canvas.drawPath(
        Path()
          ..moveTo(-100, -12)
          ..lineTo(-112, -30)
          ..lineTo(-92, -12)
          ..close(),
        Paint()..color = kAcc);

    // fuselage
    canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 80, height: 34), body);
    // cockpit glass
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(18, -2), width: 34, height: 20),
        Paint()..color = const Color(0xFF6FB6FF).withOpacity(.55));
    // accent stripe
    canvas.drawLine(
        const Offset(-24, 6),
        const Offset(14, 10),
        Paint()
          ..color = kAcc
          ..strokeWidth = 2.5);

    // skids
    canvas.drawLine(const Offset(-24, 24), const Offset(30, 24), line);
    canvas.drawLine(const Offset(-12, 14), const Offset(-14, 24), line);
    canvas.drawLine(const Offset(14, 14), const Offset(16, 24), line);

    // mast + main rotor (spins faster when you scroll faster)
    canvas.drawLine(const Offset(0, -16), const Offset(0, -24), line);
    canvas.drawOval(
        Rect.fromCenter(center: const Offset(0, -25), width: 150, height: 5),
        Paint()..color = Colors.white.withOpacity(.10));
    final bl = 72 * math.cos(d.rot);
    canvas.drawLine(
        Offset(-bl, -25),
        Offset(bl, -25),
        Paint()
          ..color = Colors.white54
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round);

    // tail rotor
    final ty = 10 * math.sin(d.rot * 1.7);
    canvas.drawLine(
        Offset(-106, -20 - ty),
        Offset(-106, -20 + ty),
        Paint()
          ..color = Colors.white54
          ..strokeWidth = 2);

    // nav lights
    final on = (math.sin(d.t * 6) > 0);
    canvas.drawCircle(const Offset(-110, -30), 2.5,
        Paint()..color = on ? Colors.redAccent : Colors.transparent);
    canvas.drawCircle(
        const Offset(36, 8), 2.5, Paint()..color = const Color(0xFF7CFFB2));
  }

  @override
  bool shouldRepaint(covariant _SkyPainter old) => true;
}
