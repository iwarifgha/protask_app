import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import 'package:task_app/task_app/utils/widgets/protask_icon_text_button.dart';
import 'package:task_app/task_app/utils/widgets/protask_text_field.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({super.key});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  TextEditingController _emailController = TextEditingController();
  bool showResetButton = false;

  _sendForgotPasswordLink() {
    context
        .read<AuthStateProvider>()
        .forgotPassword(email: _emailController.text);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reset email sent. Please check inbox')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Reset password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            ProtaskTextField(
                label: 'Enter Email',
                controller: _emailController,
                validator: (val) {
                  showResetButton = EmailValidator.validate(val);
                  return showResetButton;
                }),
            AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
                child: showResetButton
                    ? ProtaskIconTextButton(
                        icon: Icons.email,
                        text: 'Send Reset Link',
                        onPressed: _sendForgotPasswordLink)
                    : SizedBox())
          ],
        ),
      ),
    );
  }
}
