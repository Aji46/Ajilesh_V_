import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

const _acc = Color(0xFFFF5A36);
const _wa = Color(0xFF25D366);

/// Edit your contact details here.
const kWhatsAppNumber = '918943381295'; // country code + number, no "+"
const kWhatsAppDisplay = '+91 89433 81295';
const kEmail = 'ajilesh46@gmail.com';

/// Ready-made links (also usable for plain buttons elsewhere).
String waUrl([String msg = 'Hi Ajilesh, I found your portfolio and would like to talk.']) =>
    'https://wa.me/$kWhatsAppNumber?text=${Uri.encodeComponent(msg)}';

String mailUrl({String subject = 'Hello Ajilesh', String body = ''}) =>
    'mailto:$kEmail?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

Future<void> _launch(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

/// Opens the "Let's talk" popup.
Future<void> showLetsTalk(BuildContext context) => showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.black.withOpacity(.62),
      transitionDuration: const Duration(milliseconds: 380),
      pageBuilder: (_, __, ___) => const _TalkDialog(),
      transitionBuilder: (_, a, __, child) {
        final pop = CurvedAnimation(
            parent: a, curve: Curves.easeOutBack, reverseCurve: Curves.easeIn);
        return FadeTransition(
          opacity: a,
          child: AnimatedBuilder(
            animation: pop,
            child: child,
            builder: (_, c) => Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, .001)
                ..rotateX((1 - pop.value) * .35)
                ..scale(.9 + .1 * pop.value),
              child: c,
            ),
          ),
        );
      },
    );

// ───────────────────────── floating button ─────────────────────────

class LetsTalkFab extends StatefulWidget {
  const LetsTalkFab({super.key});
  @override
  State<LetsTalkFab> createState() => _LetsTalkFabState();
}

class _LetsTalkFabState extends State<LetsTalkFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500))
    ..repeat(reverse: true);
  bool _hover = false;

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 30 * (1 - v)), child: child),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => showLetsTalk(context),
          child: AnimatedScale(
            scale: _hover ? 1.07 : 1,
            duration: const Duration(milliseconds: 200),
            child: AnimatedBuilder(
              animation: _pulse,
              builder: (_, __) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                decoration: BoxDecoration(
                  color: _acc,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: [
                    BoxShadow(
                        color: _acc.withOpacity(.25 + .25 * _pulse.value),
                        blurRadius: 18 + 16 * _pulse.value,
                        spreadRadius: 1),
                  ],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0xFF7CFFB2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF7CFFB2)
                                .withOpacity(.4 + .4 * _pulse.value),
                            blurRadius: 8)
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('Let’s talk',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(width: 8),
                  const Icon(Icons.chat_bubble_rounded,
                      size: 17, color: Colors.white),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────── dialog ─────────────────────────

class _TalkDialog extends StatefulWidget {
  const _TalkDialog();
  @override
  State<_TalkDialog> createState() => _TalkDialogState();
}

class _TalkDialogState extends State<_TalkDialog> {
  final _nameC = TextEditingController();
  final _msgC = TextEditingController();
  String? _copied;

  @override
  void dispose() {
    _nameC.dispose();
    _msgC.dispose();
    super.dispose();
  }

  String _message() {
    final n = _nameC.text.trim(), m = _msgC.text.trim();
    final hi = n.isEmpty ? 'Hi Ajilesh,' : 'Hi Ajilesh, this is $n.';
    return m.isEmpty
        ? '$hi I found your portfolio and would like to talk.'
        : '$hi\n\n$m';
  }

  Future<void> _copy(String id, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    setState(() => _copied = id);
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (mounted && _copied == id) setState(() => _copied = null);
  }

  InputDecoration _dec(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.white38, fontSize: 14),
        filled: true,
        fillColor: const Color(0x14FFFFFF),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0x1FFFFFFF))),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _acc)),
      );

  @override
  Widget build(BuildContext context) {
    final inputStyle = GoogleFonts.inter(color: Colors.white, fontSize: 14);
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xE6101014),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x26FFFFFF)),
                    boxShadow: [
                      BoxShadow(
                          color: _acc.withOpacity(.25),
                          blurRadius: 80,
                          spreadRadius: -20)
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            child: Text('Let’s talk',
                                style: GoogleFonts.bebasNeue(
                                    fontSize: 46,
                                    color: Colors.white,
                                    height: .95,
                                    letterSpacing: 1)),
                          ),
                          IconButton(
                            tooltip: 'Close',
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close_rounded,
                                color: Colors.white60),
                          ),
                        ]),
                        const SizedBox(height: 4),
                        Text(
                          'Have an app idea or a security question? Message me on WhatsApp or email. I usually reply within a day.',
                          style: GoogleFonts.inter(
                              fontSize: 14, color: Colors.white70, height: 1.6),
                        ),
                        const SizedBox(height: 20),
                        _Tile(
                          icon: Icons.chat_rounded,
                          color: _wa,
                          label: 'WhatsApp',
                          value: kWhatsAppDisplay,
                          copied: _copied == 'wa',
                          onTap: () => _launch(waUrl()),
                          onCopy: () => _copy('wa', kWhatsAppDisplay),
                        ),
                        const SizedBox(height: 10),
                        _Tile(
                          icon: Icons.mail_rounded,
                          color: _acc,
                          label: 'Email',
                          value: kEmail,
                          copied: _copied == 'mail',
                          onTap: () => _launch(mailUrl()),
                          onCopy: () => _copy('mail', kEmail),
                        ),
                        const SizedBox(height: 22),
                        Text('Or write your message here',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white60,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _nameC,
                          style: inputStyle,
                          textInputAction: TextInputAction.next,
                          decoration: _dec('Your name'),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _msgC,
                          style: inputStyle,
                          minLines: 3,
                          maxLines: 5,
                          decoration: _dec('What would you like to build or ask?'),
                        ),
                        const SizedBox(height: 14),
                        Row(children: [
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  backgroundColor: _wa,
                                  foregroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              onPressed: () => _launch(waUrl(_message())),
                              icon: const Icon(Icons.chat_rounded, size: 18),
                              label: const Text('Send on WhatsApp'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  backgroundColor: _acc,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16)),
                              onPressed: () {
                                final n = _nameC.text.trim();
                                _launch(mailUrl(
                                  subject: n.isEmpty
                                      ? 'Let’s talk'
                                      : 'Let’s talk — $n',
                                  body: _message(),
                                ));
                              },
                              icon: const Icon(Icons.mail_rounded, size: 18),
                              label: const Text('Send email'),
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tile extends StatefulWidget {
  const _Tile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.onTap,
    required this.onCopy,
    required this.copied,
  });
  final IconData icon;
  final Color color;
  final String label, value;
  final VoidCallback onTap, onCopy;
  final bool copied;
  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  bool _h = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _h = true),
      onExit: (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          transform: Matrix4.translationValues(0, _h ? -3 : 0, 0),
          decoration: BoxDecoration(
            color: _h ? widget.color.withOpacity(.14) : const Color(0x0DFFFFFF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: _h ? widget.color : const Color(0x1FFFFFFF)),
          ),
          child: Row(children: [
            Container(
              width: 44,
              height: 44,
              decoration:
                  BoxDecoration(color: widget.color, shape: BoxShape.circle),
              child: Icon(widget.icon, color: Colors.black87, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.label,
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white54,
                          fontWeight: FontWeight.w600)),
                  Text(widget.value,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            IconButton(
              tooltip: widget.copied ? 'Copied' : 'Copy',
              onPressed: widget.onCopy,
              icon: Icon(
                widget.copied ? Icons.check_rounded : Icons.copy_rounded,
                size: 18,
                color: widget.copied ? widget.color : Colors.white54,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
