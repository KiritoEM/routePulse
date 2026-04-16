import 'package:flutter/material.dart';
import 'package:route_pulse_mobile/shared/widgets/custom_icon.dart';

class PasswordField extends StatefulWidget {
  final bool enabled;
  final String? hint;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PasswordField({
    super.key,
    this.enabled = true,
    this.hint = 'Mot de passe',
    this.onSaved,
    this.validator,
    this.controller,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      enabled: widget.enabled,
      controller: widget.controller,
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      onSaved: widget.onSaved,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(16),
          child: CustomIcon(path: 'assets/icons/lock.svg'),
        ),
        hintText: widget.hint,
        suffixIcon: IconButton(
          icon: !_passwordVisible
              ? CustomIcon(path: 'assets/icons/eye-slash.svg')
              : CustomIcon(path: 'assets/icons/eye.svg'),
          color: theme.colorScheme.onSurfaceVariant,
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
      ),
    );
  }
}
