part of 'widgets.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return ElevatedButton.icon(
      key: const Key('loginForm_googleLogin_elevatedButton'),
      onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
      label: Text(
        l10n.sign_in_with_google,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.colorScheme.secondary,
      ),
      icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
    );
  }
}
