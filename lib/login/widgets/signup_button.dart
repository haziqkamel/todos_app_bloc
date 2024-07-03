part of 'widgets.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return TextButton(
      key: const Key('loginForm_createAccount_textButton'),
      onPressed: () => Navigator.of(context).push<void>(SignUpPage.route()),
      child: Text(
        l10n.create_account,
        style: TextStyle(
          color: theme.brightness == Brightness.light
              ? theme.primaryColor
              : theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
