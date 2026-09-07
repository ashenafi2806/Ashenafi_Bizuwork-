import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'pin_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _MpesaMark(),
              const SizedBox(height: 58),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PinPage()),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFE21B2D),
                  textStyle: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .4,
                  ),
                ),
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 42),
              const Text(
                'M-PESA NO',
                style: TextStyle(
                  color: Color(0xFF555555),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'SIGNING IN .',
                style: TextStyle(
                  color: Color(0xFFE21B2D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.3,
                ),
              ),
              const Spacer(flex: 4),
              const Text(
                'Safaricom Ethiopia',
                style: TextStyle(color: Color(0xFF999999), fontSize: 11),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _MpesaMark extends StatelessWidget {
  const _MpesaMark();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFE21B2D),
                shape: BoxShape.circle,
              ),
              child: const Icon(Iconsax.wallet_3, color: Colors.white, size: 27),
            ),
            const SizedBox(width: 10),
            const Text(
              'M-PESA',
              style: TextStyle(
                color: Color(0xFFE21B2D),
                fontSize: 31,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'ለሁሉም',
          style: TextStyle(
            color: Color(0xFFE21B2D),
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}