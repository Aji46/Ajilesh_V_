import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/responsive.dart';

class FooterWidget extends StatelessWidget {
  const FooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = Responsive.isMobile(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.pagePadding(context),
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: mobile
              ? const Column(
                  children: [
                    _CopyrightText(),
                    SizedBox(height: 8),
                    _BuiltWithText(),
                  ],
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [_CopyrightText(), _BuiltWithText()],
                ),
        ),
      ),
    );
  }
}

class _CopyrightText extends StatelessWidget {
  const _CopyrightText();
  @override
  Widget build(BuildContext context) {
    return Text(
      '© ${DateTime.now().year} Ajilesh V. All rights reserved.',
      style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
    );
  }
}

class _BuiltWithText extends StatelessWidget {
  const _BuiltWithText();
  @override
  Widget build(BuildContext context) {
    return Text(
      'Built with Flutter 💙',
      style: TextStyle(color: AppColors.textMuted, fontSize: 12.5),
    );
  }
}
