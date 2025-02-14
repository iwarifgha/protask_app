import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/task_app/features/authentication/controller/state/auth_state_provider.dart';
import '../../notifiers/success_notifier.dart';
import '../buttons/protask_icon_text_button.dart';

class EmailVerifyDialog extends StatelessWidget {
  final String email;
  const EmailVerifyDialog({super.key, required this.email});

  _sendEmailVerifyLink(BuildContext context) {
    context.read<AuthStateProvider>().verifyEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content:  SuccessNotifier(message: 'Verification email sent. Please check your inbox')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text('Oh, Verify email, please'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            AnimatedContainer(
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 500),
                child: ProtaskIconTextButton(
                    icon: Icon(Icons.email),
                    text: 'Send link',
                    onPressed: () {
                      _sendEmailVerifyLink(context);
                    }))
          ],
        ),
      ),
    );
  }
}
