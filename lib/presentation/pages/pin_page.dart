import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/di/dependency_injection.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/auth_cubit.dart';
import 'home_page.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> {
  final _pin = <String>[];
  String _language = 'ENGLISH';

  void _addDigit(String digit) {
    if (_pin.length < 4) setState(() => _pin.add(digit));
  }

  void _removeDigit() {
    if (_pin.isNotEmpty) setState(() => _pin.removeLast());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: const Color(0xFFE21B2D)),
            );
          }
          if (state is AuthSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => HomePage(user: state.user),
              ),
            );
          }
        },
        builder: (context, state) {
          final loading = state is AuthLoading;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Iconsax.arrow_left_2, color: Color(0xFF222222)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [_languagePicker()],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ProfileHeader(),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Icon(Iconsax.lock_1, size: 19, color: Color(0xFFE21B2D)),
                        SizedBox(width: 9),
                        Text('Enter your M-PESA PIN', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 17),
                    _PinBoxes(pin: _pin),
                    const SizedBox(height: 26),
                    _Keypad(onDigit: _addDigit, onBackspace: _removeDigit),
                    const SizedBox(height: 22),
                    SizedBox(
                      height: 52,
                      child: FilledButton(
                        onPressed: loading ? null : () => context.read<AuthCubit>().signIn(_pin.join()),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFE21B2D),
                          disabledBackgroundColor: const Color(0xFFEFA6AD),
                          shape: const RoundedRectangleBorder(),
                        ),
                        child: loading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _HelpLinks(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _languagePicker() {
    return PopupMenuButton<String>(
      tooltip: 'Language preference',
      onSelected: (value) => setState(() => _language = value),
      itemBuilder: (_) => ['ENGLISH', 'AMHARIC']
          .map((language) => PopupMenuItem(value: language, child: Text(language)))
          .toList(),
      child: Row(
        children: [
          const Icon(Iconsax.language_square, color: Color(0xFFE21B2D), size: 20),
          const SizedBox(width: 7),
          Text(_language, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const Icon(Iconsax.arrow_down_1, size: 15),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      color: const Color(0xFFE21B2D),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Iconsax.user, color: Color(0xFFE21B2D), size: 30),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Welcome back', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              SizedBox(height: 6),
              Text('251 911 234 567', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PinBoxes extends StatelessWidget {
  final List<String> pin;
  const _PinBoxes({required this.pin});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final filled = index < pin.length;
        return Expanded(
          child: Container(
            height: 52,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              border: Border.all(color: filled ? const Color(0xFFE21B2D) : const Color(0xFFD8D8D8)),
            ),
            child: filled ? const Icon(Iconsax.eye_slash, size: 17, color: Color(0xFFE21B2D)) : null,
          ),
        );
      }),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  const _Keypad({required this.onDigit, required this.onBackspace});

  @override
  Widget build(BuildContext context) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'back'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisExtent: 48, mainAxisSpacing: 8, crossAxisSpacing: 10),
      itemCount: keys.length,
      itemBuilder: (_, index) {
        final key = keys[index];
        if (key.isEmpty) return const SizedBox.shrink();
        return OutlinedButton(
          onPressed: key == 'back' ? onBackspace : () => onDigit(key),
          style: OutlinedButton.styleFrom(shape: const RoundedRectangleBorder(), side: const BorderSide(color: Color(0xFFE3E3E3))),
          child: key == 'back' ? const Icon(Iconsax.backspace, size: 19, color: Color(0xFF444444)) : Text(key, style: const TextStyle(fontSize: 18, color: Color(0xFF222222))),
        );
      },
    );
  }
}

class _HelpLinks extends StatelessWidget {
  const _HelpLinks();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        _HelpItem(icon: Iconsax.message_question, label: 'Forgot PIN?'),
        _HelpItem(icon: Iconsax.message_question, label: 'Contact-Us'),
        _HelpItem(icon: Iconsax.info_circle, label: 'Terms & conditions'),
      ],
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _HelpItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          Icon(icon, size: 19, color: const Color(0xFF666666)),
          const SizedBox(height: 5),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Color(0xFF666666))),
        ],
      ),
    );
  }
}