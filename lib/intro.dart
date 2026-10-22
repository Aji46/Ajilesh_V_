import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _bg = Color(0xFF0A0A0C);
const _acc = Color(0xFFFF5A36);
const _grn = Color(0xFF7CFFB2);

double _c01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);

/// Full-screen intro:
///  1. code rain + a terminal "boots" the portfolio (typed commands + progress)
///  2. the name decodes letter by letter with a glitch
///  3. the screen splits open through the middle and the portfolio flies in
///
/// [onReveal] fires the moment the split starts (start the portfolio's own
/// entrance animations there). [onDone] fires when the overlay can be removed.
/// Tap anywhere or press SKIP to jump to the reveal.
class IntroOverlay extends StatefulWidget {
  const IntroOverlay({super.key, required this.onReveal, required this.onDone});
  final VoidCallback onReveal;
  final VoidCallback onDone;
  @override
  State<IntroOverlay> createState() => _IntroOverlayState();
}

class _IntroOverlayState extends State<IntroOverlay>
    with SingleTickerProviderStateMixin {
  static const _ms = 5600; // total length
  static const _curtain = .80; // when the split starts (0..1)

  static const _lines = [
    r'$ flutter create ajilesh_portfolio',
    r'> project created ........ ok',
    r'$ dart pub get',
    r'$ nmap -sV --script vuln localhost',
    r'> 0 vulnerabilities found · system secure',
    r'$ flutter build web --release',
    r'> compiling 3D scenes ........ done',
  ];

  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: _ms));
  bool _revealed = false;

  @override
  void initState() {
    super.initState();
    _c.addListener(() {
      if (!_revealed && _c.value >= _curtain) {
        _revealed = true;
        widget.onReveal();
      }
    });
    _c.addStatusListener((s) {
      if (s == AnimationStatus.completed) widget.onDone();
    });
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _skip() {
    if (_c.value >= .76) return;
    _c
        .animateTo(.76,
            duration: const Duration(milliseconds: 250), curve: Curves.easeOut)
        .then((_) {
      if (mounted) _c.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: LayoutBuilder(builder: (context, box) {
        final w = box.maxWidth, h = box.maxHeight;
        return AnimatedBuilder(
          animation: _c,
          builder: (_, __) {
            final t = _c.value;
            final e = Curves.easeInOutCubic
                .transform(_c01((t - _curtain) / (1 - _curtain)));
            final base = SizedBox(width: w, height: h, child: _scene(t, w, h, e));

            // The same picture, drawn twice: top half slides up, bottom half
            // slides down, opening a gap that shows the portfolio.
            Widget half(bool top) => Positioned(
                  left: 0,
                  right: 0,
                  top: top ? 0 : null,
                  bottom: top ? null : 0,
                  height: h / 2,
                  child: Transform.translate(
                    offset: Offset(0, (top ? -1 : 1) * e * (h / 2 + 40)),
                    child: ClipRect(
                      child: OverflowBox(
                        alignment:
                            top ? Alignment.topCenter : Alignment.bottomCenter,
                        minWidth: w,
                        maxWidth: w,
                        minHeight: h,
                        maxHeight: h,
                        child: base,
                      ),
                    ),
                  ),
                );

            final seam = Positioned(
              left: 0,
              right: 0,
              top: h / 2 - 1,
              height: 2,
              child: Opacity(
                opacity: _c01(1 - e * 1.6),
                child: DecoratedBox(
                  decoration: BoxDecoration(color: _acc, boxShadow: [
                    BoxShadow(
                        color: _acc.withOpacity(.8),
                        blurRadius: 24,
                        spreadRadius: 2)
                  ]),
                ),
              ),
            );

            return IgnorePointer(
              ignoring: t >= _curtain,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _skip,
                child: Stack(fit: StackFit.expand, children: [
                  if (e <= 0) base else ...[half(true), half(false), seam],
                  if (t < _curtain)
                    Positioned(
                      right: 24,
                      bottom: 22,
                      child: TextButton(
                        onPressed: _skip,
                        child: Text('SKIP  ›',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.white54,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 3)),
                      ),
                    ),
                ]),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _scene(double t, double w, double h, double e) {
    final secs = t * _ms / 1000;
    final rainOp =
        _c01(t / .06) * (t < .6 ? .5 : .5 - .3 * _c01((t - .6) / .2));
    return Stack(fit: StackFit.expand, children: [
      const ColoredBox(color: _bg),
      Opacity(
        opacity: rainOp,
        child: CustomPaint(size: Size(w, h), painter: _RainPainter(secs)),
      ),
      Positioned.fill(
        child: Opacity(
          opacity: _c01((t - .55) / .15),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                  radius: .7, colors: [Color(0x40FF5A36), Colors.transparent]),
            ),
          ),
        ),
      ),
      Center(child: _terminal(t, w)),
      Center(
        child: Transform.scale(scale: 1 + e * .9, child: _name(t, w)),
      ),
    ]);
  }

  // ───────────────────────── terminal ─────────────────────────
  Widget _terminal(double t, double w) {
    final out = _c01((t - .54) / .08);
    if (out >= 1) return const SizedBox.shrink();
    final pw = math.min(640.0, w * .9);
    final fs = w < 600 ? 11.5 : 13.5;
    final lh = fs * 1.75;
    final prog = _c01(Curves.easeInOut.transform(_c01((t - .02) / .52)));
    final secs = t * _ms / 1000;

    final vis = <String>[];
    var lastTyping = false;
    for (var i = 0; i < _lines.length; i++) {
      final k = _c01((t - (.02 + i * .07)) / .08);
      if (k <= 0) break;
      final s = _lines[i];
      vis.add(s.substring(0, (s.length * k).round()));
      lastTyping = k < 1;
    }
    final blink = (secs * 3).floor().isEven;

    Widget dot(int c) => Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(color: Color(c), shape: BoxShape.circle),
        );

    final mono = GoogleFonts.jetBrainsMono;

    return Opacity(
      opacity: _c01(t / .05) * (1 - out),
      child: Transform.translate(
        offset: Offset(0, -24 * out),
        child: Transform.scale(
          scale: 1 - .08 * out,
          child: Container(
            width: pw,
            decoration: BoxDecoration(
              color: const Color(0xD90E0E12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0x1FFFFFFF)),
              boxShadow: [
                BoxShadow(
                    color: _acc.withOpacity(.14),
                    blurRadius: 60,
                    spreadRadius: -8)
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                  child: Row(children: [
                    dot(0xFFFF5F57),
                    dot(0xFFFEBC2E),
                    dot(0xFF28C840),
                    const SizedBox(width: 8),
                    Text('ajilesh@portfolio:~',
                        style: mono(fontSize: 11, color: Colors.white38)),
                  ]),
                ),
                const Divider(height: 1, color: Color(0x14FFFFFF)),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 6),
                  child: SizedBox(
                    height: lh * _lines.length,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var i = 0; i < vis.length; i++)
                          _line(
                            vis[i],
                            i == vis.length - 1 && (lastTyping || blink),
                            fs,
                            lh,
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                  child: Row(children: [
                    Text('BUILD',
                        style: mono(
                            fontSize: 11, color: Colors.white54, letterSpacing: 2)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Stack(children: [
                          Container(height: 4, color: const Color(0x1FFFFFFF)),
                          FractionallySizedBox(
                            widthFactor: prog,
                            child: Container(
                              height: 4,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [_acc, Color(0xFFFFB27A)]),
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 40,
                      child: Text('${(prog * 100).round()}%',
                          textAlign: TextAlign.right,
                          style: mono(fontSize: 11, color: Colors.white70)),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _line(String s, bool cursor, double fs, double lh) {
    final isOut = s.startsWith('>');
    final st = GoogleFonts.jetBrainsMono(
        fontSize: fs, color: isOut ? _grn : Colors.white70, height: 1.3);
    return SizedBox(
      height: lh,
      child: Text.rich(
        TextSpan(style: st, children: [
          if (s.isNotEmpty && !isOut)
            TextSpan(
                text: s.substring(0, 1),
                style: st.copyWith(color: _acc, fontWeight: FontWeight.w700)),
          TextSpan(text: isOut ? s : (s.isEmpty ? '' : s.substring(1))),
          if (cursor) TextSpan(text: '▌', style: st.copyWith(color: _acc)),
        ]),
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    );
  }

  // ───────────────────────── name decode ─────────────────────────
  Widget _name(double t, double w) {
    final k = _c01((t - .58) / .24);
    if (k <= 0) return const SizedBox.shrink();

    const full = 'AJILESH V';
    const pool = 'ABCDEFGHJKLMNPRSTUVXYZ0123456789<>/{}#';
    final tick = (t * _ms / 45).floor();
    final sb = StringBuffer();
    for (var i = 0; i < full.length; i++) {
      if (full[i] == ' ' || k * 1.15 > (i + 1) / full.length) {
        sb.write(full[i]);
      } else {
        sb.write(pool[(tick * 31 + i * 17) % pool.length]);
      }
    }
    final str = sb.toString();

    final size = w > 900 ? 150.0 : (w > 560 ? 100.0 : 62.0);
    final ek = _c01((k - .8) / .2); // extrusion grows once decoded

    TextStyle st(Color c, {bool ext = false}) => GoogleFonts.bebasNeue(
          fontSize: size,
          color: c,
          height: .95,
          letterSpacing: 4,
          shadows: ext && ek > 0
              ? [
                  for (var i = 1; i <= 8; i++)
                    Shadow(
                      color: Color.lerp(
                          const Color(0xFF8A2A12), Colors.black, i / 8)!,
                      offset: Offset(i * 1.1 * ek, i * 1.3 * ek),
                    )
                ]
              : null,
        );

    // chromatic-aberration glitch while letters are still scrambling
    final fl = ((tick * 7919) % 10) / 10;
    final gl = (1 - k) * 9 * fl;

    final sk = _c01((t - .70) / .14);
    final lineW = (w < 560 ? 180.0 : 320.0) *
        Curves.easeOutCubic.transform(_c01((t - .66) / .14));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Opacity(
          opacity: _c01(k * 3),
          child: Text('// hello, world',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 13, color: _acc, letterSpacing: 2)),
        ),
        const SizedBox(height: 8),
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (gl > .4)
              Transform.translate(
                  offset: Offset(-gl, 0),
                  child: Text(str, style: st(_acc.withOpacity(.8)))),
            if (gl > .4)
              Transform.translate(
                  offset: Offset(gl, 0),
                  child: Text(str,
                      style: st(const Color(0xFF38E8FF).withOpacity(.6)))),
            Text(str, style: st(Colors.white, ext: true)),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: lineW,
          height: 2,
          decoration: BoxDecoration(color: _acc, boxShadow: [
            BoxShadow(color: _acc.withOpacity(.7), blurRadius: 14)
          ]),
        ),
        const SizedBox(height: 16),
        Opacity(
          opacity: sk,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'FLUTTER DEVELOPER  ·  CYBER SECURITY RESEARCHER',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: w < 560 ? 11 : 14,
                color: Colors.white70,
                fontWeight: FontWeight.w600,
                letterSpacing: 10 - 6 * Curves.easeOut.transform(sk),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── code rain ─────────────────────────

class _RainPainter extends CustomPainter {
  _RainPainter(this.t);
  final double t; // seconds

  static const _glyphs = r'01{}[]<>/=;()+*#$&@xyzFLUTTER';
  static const _lh = 20.0, _cw = 24.0;
  static List<List<TextPainter>>? _cache;

  // 4 brightness levels (head, bright, mid, dim) x every glyph, built once
  static List<List<TextPainter>> _build() {
    final cols = <Color>[
      Colors.white.withOpacity(.95),
      _acc.withOpacity(.9),
      _acc.withOpacity(.45),
      _acc.withOpacity(.18),
    ];
    return [
      for (final c in cols)
        [
          for (var g = 0; g < _glyphs.length; g++)
            TextPainter(
              text: TextSpan(
                  text: _glyphs[g],
                  style: GoogleFonts.jetBrainsMono(fontSize: 15, color: c)),
              textDirection: TextDirection.ltr,
            )..layout(),
        ]
    ];
  }

  static double _h(int n) {
    final s = math.sin(n * 12.9898) * 43758.5453;
    return s - s.floorToDouble();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final cache = _cache ??= _build();
    final rows = (size.height / _lh).ceil();
    final cols = (size.width / _cw).ceil();
    for (var c = 0; c < cols; c++) {
      final r1 = _h(c * 7 + 1), r2 = _h(c * 13 + 5), r3 = _h(c * 29 + 9);
      final speed = 4 + r1 * 9; // rows per second
      final trail = 6 + (r2 * 12).floor();
      final cycle = rows + trail + 10 + (r3 * 20).floor();
      final head = (t * speed + r3 * cycle) % cycle;
      for (var k = 0; k < trail; k++) {
        final row = (head - k).floor();
        if (row < 0 || row >= rows) continue;
        final lvl = k == 0 ? 0 : (k < 3 ? 1 : (k < trail * .5 ? 2 : 3));
        final flip = ((row + c) % 3 == 0) ? (t * 3).floor() : 0;
        final g = (c * 31 + row * 17 + flip) % _glyphs.length;
        cache[lvl][g].paint(canvas, Offset(c * _cw + 4, row * _lh));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter old) => old.t != t;
}
