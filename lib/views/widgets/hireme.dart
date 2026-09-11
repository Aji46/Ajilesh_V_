
// import 'package:ajilesh_portfolio/controllers/portfolio_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../../controllers/portfolio_provider.dart';
// import '../../utils/app_colors.dart';
// import '../../utils/responsive.dart';

// class HireMePage extends StatefulWidget {
//   const HireMePage({super.key});

//   @override
//   State<HireMePage> createState() => _HireMePageState();
// }

// class _HireMePageState extends State<HireMePage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController _nameController =
//       TextEditingController();

//   final TextEditingController _emailController =
//       TextEditingController();

//   final TextEditingController _messageController =
//       TextEditingController();

//   bool _sending = false;

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _messageController.dispose();
//     super.dispose();
//   }

//   // ============================================================
//   // SEND MESSAGE
//   // ============================================================

//   Future<void> _sendMessage(
//     PortfolioProvider portfolio,
//   ) async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     setState(() {
//       _sending = true;
//     });

//     final emailUri = Uri(
//       scheme: 'mailto',
//       queryParameters: {
//         'subject': 'Hire request from ${_nameController.text.trim()}',
//         'body': [
//           'Name: ${_nameController.text.trim()}',
//           'Email: ${_emailController.text.trim()}',
//           '',
//           _messageController.text.trim(),
//         ].join('\n'),
//       },
//     );

//     await launchUrl(emailUri);

//     if (!mounted) return;

//     setState(() {
//       _sending = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text(
//           'Opening your email application...',
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // VALIDATE REQUIRED FIELD
//   // ============================================================

//   String? _required(
//     String? value,
//     String field,
//   ) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter your $field';
//     }

//     return null;
//   }

//   // ============================================================
//   // VALIDATE EMAIL
//   // ============================================================

//   String? _validateEmail(
//     String? value,
//   ) {
//     if (value == null || value.trim().isEmpty) {
//       return 'Please enter your email';
//     }

//     final email = value.trim();

//     final emailRegex = RegExp(
//       r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
//     );

//     if (!emailRegex.hasMatch(email)) {
//       return 'Please enter a valid email';
//     }

//     return null;
//   }

//   // ============================================================
//   // INPUT DECORATION
//   // ============================================================

//   InputDecoration _inputDecoration({
//     required String label,
//     required IconData icon,
//   }) {
//     return InputDecoration(
//       labelText: label,

//       prefixIcon: Icon(
//         icon,
//         color: AppColors.textMuted,
//       ),

//       filled: true,

//       fillColor: AppColors.background.withOpacity(0.55),

//       contentPadding: const EdgeInsets.symmetric(
//         horizontal: 18,
//         vertical: 17,
//       ),

//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: AppColors.divider,
//         ),
//       ),

//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: AppColors.divider,
//         ),
//       ),

//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: AppColors.accent,
//           width: 1.5,
//         ),
//       ),

//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//         ),
//       ),

//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(14),
//         borderSide: const BorderSide(
//           color: Colors.redAccent,
//           width: 1.5,
//         ),
//       ),

//       labelStyle: const TextStyle(
//         color: AppColors.textMuted,
//       ),
//     );
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     final portfolio = context.watch<PortfolioProvider>();

//     final mobile = Responsive.isMobile(context);

//     return Scaffold(
//       body: Container(
//         width: double.infinity,

//         decoration: const BoxDecoration(
//           gradient: AppColors.heroGradient,
//         ),

//         child: SafeArea(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(
//               horizontal: Responsive.pagePadding(context),
//               vertical: mobile ? 35 : 70,
//             ),

//             child: Center(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth:
//                       Responsive.maxContentWidth(context),
//                 ),

//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,

//                   children: [

//                     // ==================================================
//                     // BACK BUTTON
//                     // ==================================================

//                     TextButton.icon(
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },

//                       icon: const Icon(
//                         Icons.arrow_back_rounded,
//                       ),

//                       label: const Text(
//                         'Back to Portfolio',
//                       ),

//                       style: TextButton.styleFrom(
//                         foregroundColor:
//                             AppColors.textSecondary,
//                       ),
//                     ),

//                     SizedBox(
//                       height: mobile ? 35 : 55,
//                     ),

//                     // ==================================================
//                     // HEADER
//                     // ==================================================

//                     _buildHeader(
//                       portfolio,
//                       mobile,
//                     ),

//                     const SizedBox(height: 50),

//                     // ==================================================
//                     // MAIN CONTENT
//                     // ==================================================

//                     mobile
//                         ? Column(
//                             children: [
//                               _buildAboutCard(
//                                 portfolio,
//                               ),

//                               const SizedBox(
//                                 height: 25,
//                               ),

//                               _buildHireForm(
//                                 portfolio,
//                               ),
//                             ],
//                           )
//                         : Row(
//                             crossAxisAlignment:
//                                 CrossAxisAlignment.start,

//                             children: [

//                               Expanded(
//                                 flex: 4,

//                                 child:
//                                     _buildAboutCard(
//                                   portfolio,
//                                 ),
//                               ),

//                               const SizedBox(
//                                 width: 30,
//                               ),

//                               Expanded(
//                                 flex: 6,

//                                 child:
//                                     _buildHireForm(
//                                   portfolio,
//                                 ),
//                               ),
//                             ],
//                           ),

//                     const SizedBox(height: 45),

//                     // ==================================================
//                     // FOOTER MESSAGE
//                     // ==================================================

//                     Center(
//                       child: Text(
//                         'Let\'s turn your idea into something great.',
//                         textAlign: TextAlign.center,

//                         style: TextStyle(
//                           color:
//                               AppColors.textMuted,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // HEADER
//   // ============================================================

//   Widget _buildHeader(
//     PortfolioProvider portfolio,
//     bool mobile,
//   ) {
//     return Column(
//       crossAxisAlignment:
//           mobile
//               ? CrossAxisAlignment.center
//               : CrossAxisAlignment.start,

//       children: [

//         // SMALL BADGE

//         Container(
//           padding: const EdgeInsets.symmetric(
//             horizontal: 14,
//             vertical: 8,
//           ),

//           decoration: BoxDecoration(
//             color: AppColors.accent
//                 .withOpacity(0.10),

//             borderRadius:
//                 BorderRadius.circular(30),

//             border: Border.all(
//               color: AppColors.accent
//                   .withOpacity(0.25),
//             ),
//           ),

//           child: Row(
//             mainAxisSize:
//                 MainAxisSize.min,

//             children: const [

//               Icon(
//                 Icons.circle,
//                 size: 8,
//                 color: AppColors.accent,
//               ),

//               SizedBox(width: 8),

//               Text(
//                 'AVAILABLE FOR WORK',
//                 style: TextStyle(
//                   color: AppColors.accent,
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 20),

//         // TITLE

//         Text(
//           'Let\'s Work Together',
//           textAlign:
//               mobile
//                   ? TextAlign.center
//                   : TextAlign.left,

//           style: TextStyle(
//             color: AppColors.textPrimary,

//             fontSize:
//                 mobile ? 34 : 48,

//             height: 1.1,

//             fontWeight:
//                 FontWeight.w900,
//           ),
//         ),

//         const SizedBox(height: 15),

//         // SUBTITLE

//         ConstrainedBox(
//           constraints: const BoxConstraints(
//             maxWidth: 700,
//           ),

//           child: Text(
//             'Have an idea, project, or opportunity? '
//             'Tell me about it and let\'s discuss how '
//             'we can bring it to life.',
//             textAlign:
//                 mobile
//                     ? TextAlign.center
//                     : TextAlign.left,

//             style: const TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 16,
//               height: 1.7,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // ABOUT CARD
//   // ============================================================

//   Widget _buildAboutCard(
//     PortfolioProvider portfolio,
//   ) {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(30),

//       decoration: BoxDecoration(
//         gradient: AppColors.cardGradient,

//         borderRadius:
//             BorderRadius.circular(24),

//         border: Border.all(
//           color: AppColors.divider,
//         ),
//       ),

//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,

//         children: [

//           // ICON

//           Container(
//             width: 60,
//             height: 60,

//             decoration: BoxDecoration(
//               gradient:
//                   AppColors.accentGradient,

//               borderRadius:
//                   BorderRadius.circular(17),

//               boxShadow: [
//                 BoxShadow(
//                   color: AppColors.accent
//                       .withOpacity(0.20),

//                   blurRadius: 25,
//                 ),
//               ],
//             ),

//             child: const Icon(
//               Icons.rocket_launch_rounded,
//               color: Colors.white,
//               size: 28,
//             ),
//           ),

//           const SizedBox(height: 25),

//           const Text(
//             'Why Work With Me?',
//             style: TextStyle(
//               color: AppColors.textPrimary,
//               fontSize: 23,
//               fontWeight: FontWeight.w800,
//             ),
//           ),

//           const SizedBox(height: 14),

//           const Text(
//             'I build modern, responsive and scalable '
//             'applications with a strong focus on clean '
//             'UI, good user experience and maintainable code.',
//             style: TextStyle(
//               color: AppColors.textSecondary,
//               fontSize: 14,
//               height: 1.75,
//             ),
//           ),

//           const SizedBox(height: 28),

//           _buildService(
//             Icons.flutter_dash,
//             'Flutter Development',
//             'Beautiful cross-platform applications.',
//           ),

//           const SizedBox(height: 18),

//           _buildService(
//             Icons.phone_android_rounded,
//             'Mobile Applications',
//             'Android, iOS and responsive experiences.',
//           ),

//           const SizedBox(height: 18),

//           _buildService(
//             Icons.language_rounded,
//             'Web Applications',
//             'Responsive Flutter web applications.',
//           ),

//           const SizedBox(height: 18),

//           _buildService(
//             Icons.api_rounded,
//             'API Integration',
//             'REST APIs and backend integration.',
//           ),

//           const SizedBox(height: 18),

//           _buildService(
//             Icons.code_rounded,
//             'Clean Code',
//             'Maintainable and scalable architecture.',
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SERVICE ITEM
//   // ============================================================

//   Widget _buildService(
//     IconData icon,
//     String title,
//     String subtitle,
//   ) {
//     return Row(
//       crossAxisAlignment:
//           CrossAxisAlignment.start,

//       children: [

//         Container(
//           width: 42,
//           height: 42,

//           decoration: BoxDecoration(
//             color: AppColors.accent
//                 .withOpacity(0.10),

//             borderRadius:
//                 BorderRadius.circular(12),
//           ),

//           child: Icon(
//             icon,
//             size: 20,
//             color: AppColors.accent,
//           ),
//         ),

//         const SizedBox(width: 14),

//         Expanded(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,

//             children: [

//               Text(
//                 title,
//                 style: const TextStyle(
//                   color:
//                       AppColors.textPrimary,
//                   fontSize: 14,
//                   fontWeight:
//                       FontWeight.w700,
//                 ),
//               ),

//               const SizedBox(height: 4),

//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color:
//                       AppColors.textMuted,
//                   fontSize: 12,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // HIRE FORM
//   // ============================================================

//   Widget _buildHireForm(
//     PortfolioProvider portfolio,
//   ) {
//     return Container(
//       width: double.infinity,

//       padding: const EdgeInsets.all(30),

//       decoration: BoxDecoration(
//         color: AppColors.background,

//         borderRadius:
//             BorderRadius.circular(24),

//         border: Border.all(
//           color: AppColors.accent
//               .withOpacity(0.25),
//         ),

//         boxShadow: [
//           BoxShadow(
//             color: Colors.black
//                 .withOpacity(0.15),

//             blurRadius: 30,

//             offset:
//                 const Offset(0, 15),
//           ),
//         ],
//       ),

//       child: Form(
//         key: _formKey,

//         child: Column(
//           crossAxisAlignment:
//               CrossAxisAlignment.start,

//           children: [

//             const Text(
//               'Tell Me About Your Project',
//               style: TextStyle(
//                 color:
//                     AppColors.textPrimary,
//                 fontSize: 22,
//                 fontWeight:
//                     FontWeight.w800,
//               ),
//             ),

//             const SizedBox(height: 7),

//             const Text(
//               'I\'ll get back to you as soon as possible.',
//               style: TextStyle(
//                 color:
//                     AppColors.textMuted,
//                 fontSize: 13,
//               ),
//             ),

//             const SizedBox(height: 25),

//             // NAME

//             TextFormField(
//               controller:
//                   _nameController,

//               textInputAction:
//                   TextInputAction.next,

//               decoration:
//                   _inputDecoration(
//                 label: 'Your Name',
//                 icon:
//                     Icons.person_outline,
//               ),

//               validator: (value) =>
//                   _required(
//                 value,
//                 'your name',
//               ),
//             ),

//             const SizedBox(height: 16),

//             // EMAIL

//             TextFormField(
//               controller:
//                   _emailController,

//               keyboardType:
//                   TextInputType.emailAddress,

//               textInputAction:
//                   TextInputAction.next,

//               decoration:
//                   _inputDecoration(
//                 label: 'Your Email',
//                 icon:
//                     Icons.email_outlined,
//               ),

//               validator:
//                   _validateEmail,
//             ),

//             const SizedBox(height: 16),

//             // MESSAGE

//             TextFormField(
//               controller:
//                   _messageController,

//               minLines: 6,
//               maxLines: 9,

//               textInputAction:
//                   TextInputAction.newline,

//               decoration:
//                   _inputDecoration(
//                 label:
//                     'Project details / Message',
//                 icon:
//                     Icons.chat_bubble_outline,
//               ).copyWith(
//                 alignLabelWithHint: true,
//               ),

//               validator: (value) =>
//                   _required(
//                 value,
//                 'project details',
//               ),
//             ),

//             const SizedBox(height: 22),

//             // SEND BUTTON

//             SizedBox(
//               width: double.infinity,
//               height: 56,

//               child:
//                   FilledButton.icon(
//                 onPressed: _sending
//                     ? null
//                     : () => _sendMessage(
//                           portfolio,
//                         ),

//                 icon: _sending
//                     ? const SizedBox(
//                         width: 19,
//                         height: 19,

//                         child:
//                             CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color:
//                               Colors.white,
//                         ),
//                       )
//                     : const Icon(
//                         Icons.send_rounded,
//                       ),

//                 label: Text(
//                   _sending
//                       ? 'Opening Email...'
//                       : 'Send Message',
//                 ),

//                 style:
//                     FilledButton.styleFrom(
//                   backgroundColor:
//                       AppColors.accent,

//                   disabledBackgroundColor:
//                       AppColors.accent
//                           .withOpacity(
//                     0.5,
//                   ),

//                   foregroundColor:
//                       Colors.white,

//                   shape:
//                       RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(
//                       14,
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 15),

//             // EMAIL INFORMATION

//             Row(
//               mainAxisAlignment:
//                   MainAxisAlignment.center,

//               children: const [

//                 Icon(
//                   Icons.email_outlined,
//                   size: 14,
//                   color:
//                       AppColors.textMuted,
//                 ),

//                 SizedBox(width: 7),

//                 Flexible(
//                   child: Text(
//                     'The message will be sent through your email application.',
//                     textAlign:
//                         TextAlign.center,

//                     style: TextStyle(
//                       color:
//                           AppColors.textMuted,
//                       fontSize: 11.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/portfolio_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class HireMePage extends StatefulWidget {
  const HireMePage({super.key});

  @override
  State<HireMePage> createState() => _HireMePageState();
}

class _HireMePageState extends State<HireMePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _emailController =
      TextEditingController();

  final TextEditingController _messageController =
      TextEditingController();

  bool _sending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  Future<void> _sendMessage(
    PortfolioProvider portfolio,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _sending = true;
    });

    final emailUri = Uri(
      scheme: 'mailto',
      queryParameters: {
        'subject':
            'Hire request from ${_nameController.text.trim()}',
        'body': [
          'Name: ${_nameController.text.trim()}',
          'Email: ${_emailController.text.trim()}',
          '',
          _messageController.text.trim(),
        ].join('\n'),
      },
    );

    try {
      final launched = await launchUrl(emailUri);

      if (!mounted) return;

      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open your email application.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Opening your email application...',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to open the email application.',
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      _sending = false;
    });
  }

  // ============================================================
  // VALIDATE REQUIRED FIELD
  // ============================================================

  String? _required(
    String? value,
    String field,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $field';
    }

    return null;
  }

  // ============================================================
  // VALIDATE EMAIL
  // ============================================================

  String? _validateEmail(
    String? value,
  ) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    final email = value.trim();

    final emailRegex = RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  // ============================================================
  // INPUT DECORATION
  // ============================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(
        icon,
        color: AppColors.textMuted,
      ),

      filled: true,

      fillColor: AppColors.background.withOpacity(0.55),

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 17,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.divider,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.divider,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.accent,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.5,
        ),
      ),

      labelStyle: const TextStyle(
        color: AppColors.textMuted,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final portfolio = context.watch<PortfolioProvider>();

    final mobile = Responsive.isMobile(context);

    // IMPORTANT:
    // No Scaffold here.
    // No SingleChildScrollView here.
    //
    // HomeView already provides the main scrolling area.

    return Container(
      width: double.infinity,

      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),

      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.pagePadding(context),
            vertical: mobile ? 35 : 70,
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.maxContentWidth(context),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  _buildHeader(
                    portfolio,
                    mobile,
                  ),

                  SizedBox(
                    height: mobile ? 35 : 55,
                  ),

                  // ==================================================
                  // MAIN CONTENT
                  // ==================================================

                  mobile
                      ? Column(
                          children: [
                            _buildAboutCard(
                              portfolio,
                            ),

                            const SizedBox(
                              height: 25,
                            ),

                            _buildHireForm(
                              portfolio,
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [
                            Expanded(
                              flex: 4,
                              child: _buildAboutCard(
                                portfolio,
                              ),
                            ),

                            const SizedBox(
                              width: 30,
                            ),

                            Expanded(
                              flex: 6,
                              child: _buildHireForm(
                                portfolio,
                              ),
                            ),
                          ],
                        ),

                  const SizedBox(height: 45),

                  // ==================================================
                  // FOOTER MESSAGE
                  // ==================================================

                  Center(
                    child: Text(
                      'Let\'s turn your idea into something great.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader(
    PortfolioProvider portfolio,
    bool mobile,
  ) {
    return Column(
      crossAxisAlignment: mobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        // BADGE

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 8,
          ),

          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(30),

            border: Border.all(
              color: AppColors.accent.withOpacity(0.25),
            ),
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,

            children: const [
              Icon(
                Icons.circle,
                size: 8,
                color: AppColors.accent,
              ),

              SizedBox(width: 8),

              Text(
                'AVAILABLE FOR WORK',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // TITLE

        Text(
          'Let\'s Work Together',

          textAlign:
              mobile ? TextAlign.center : TextAlign.left,

          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: mobile ? 34 : 48,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 15),

        // SUBTITLE

        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 700,
          ),

          child: Text(
            'Have an idea, project, or opportunity? '
            'Tell me about it and let\'s discuss how '
            'we can bring it to life.',

            textAlign:
                mobile ? TextAlign.center : TextAlign.left,

            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ABOUT CARD
  // ============================================================

  Widget _buildAboutCard(
    PortfolioProvider portfolio,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: AppColors.divider,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Container(
            width: 60,
            height: 60,

            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,

              borderRadius:
                  BorderRadius.circular(17),

              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.20),
                  blurRadius: 25,
                ),
              ],
            ),

            child: const Icon(
              Icons.rocket_launch_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Why Work With Me?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'I build modern, responsive and scalable '
            'applications with a strong focus on clean '
            'UI, good user experience and maintainable code.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.75,
            ),
          ),

          const SizedBox(height: 28),

          _buildService(
            Icons.flutter_dash,
            'Flutter Development',
            'Beautiful cross-platform applications.',
          ),

          const SizedBox(height: 18),

          _buildService(
            Icons.phone_android_rounded,
            'Mobile Applications',
            'Android, iOS and responsive experiences.',
          ),

          const SizedBox(height: 18),

          _buildService(
            Icons.language_rounded,
            'Web Applications',
            'Responsive Flutter web applications.',
          ),

          const SizedBox(height: 18),

          _buildService(
            Icons.api_rounded,
            'API Integration',
            'REST APIs and backend integration.',
          ),

          const SizedBox(height: 18),

          _buildService(
            Icons.code_rounded,
            'Clean Code',
            'Maintainable and scalable architecture.',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SERVICE ITEM
  // ============================================================

  Widget _buildService(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.10),

            borderRadius:
                BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            size: 20,
            color: AppColors.accent,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // HIRE FORM
  // ============================================================

  Widget _buildHireForm(
    PortfolioProvider portfolio,
  ) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: AppColors.background,

        borderRadius:
            BorderRadius.circular(24),

        border: Border.all(
          color: AppColors.accent.withOpacity(0.25),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),

      child: Form(
        key: _formKey,

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            const Text(
              'Tell Me About Your Project',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'I\'ll get back to you as soon as possible.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 25),

            // NAME

            TextFormField(
              controller: _nameController,

              textInputAction:
                  TextInputAction.next,

              decoration: _inputDecoration(
                label: 'Your Name',
                icon: Icons.person_outline,
              ),

              validator: (value) =>
                  _required(
                value,
                'your name',
              ),
            ),

            const SizedBox(height: 16),

            // EMAIL

            TextFormField(
              controller: _emailController,

              keyboardType:
                  TextInputType.emailAddress,

              textInputAction:
                  TextInputAction.next,

              decoration: _inputDecoration(
                label: 'Your Email',
                icon: Icons.email_outlined,
              ),

              validator:
                  _validateEmail,
            ),

            const SizedBox(height: 16),

            // MESSAGE

            TextFormField(
              controller: _messageController,

              minLines: 6,
              maxLines: 9,

              textInputAction:
                  TextInputAction.newline,

              decoration: _inputDecoration(
                label: 'Project details / Message',
                icon: Icons.chat_bubble_outline,
              ).copyWith(
                alignLabelWithHint: true,
              ),

              validator: (value) =>
                  _required(
                value,
                'project details',
              ),
            ),

            const SizedBox(height: 22),

            // SEND BUTTON

            SizedBox(
              width: double.infinity,
              height: 56,

              child: FilledButton.icon(
                onPressed: _sending
                    ? null
                    : () => _sendMessage(
                          portfolio,
                        ),

                icon: _sending
                    ? const SizedBox(
                        width: 19,
                        height: 19,

                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                      ),

                label: Text(
                  _sending
                      ? 'Opening Email...'
                      : 'Send Message',
                ),

                style: FilledButton.styleFrom(
                  backgroundColor:
                      AppColors.accent,

                  disabledBackgroundColor:
                      AppColors.accent.withOpacity(0.5),

                  foregroundColor:
                      Colors.white,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // EMAIL INFORMATION

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: const [
                Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: AppColors.textMuted,
                ),

                SizedBox(width: 7),

                Flexible(
                  child: Text(
                    'The message will be sent through your email application.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}