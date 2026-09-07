import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/entities/user_entity.dart';

class HomePage extends StatefulWidget {
  final UserEntity user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showBalances = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _TopBar(),
              const SizedBox(height: 25),
              _BalanceCard(
                user: widget.user,
                showBalances: _showBalances,
                onToggleVisibility: () => setState(() => _showBalances = !_showBalances),
              ),
              const SizedBox(height: 22),
              const _ServiceGrid(),
              const SizedBox(height: 28),
              const Text(
                'Transactions',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              const _TransactionList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: Colors.white,
          child: Text(
            'AM',
            style: TextStyle(
              color: Color(0xFFE21B2D),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            children: [
              const Text(
                'Good Morning, Aster',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(width: 6),
              const Text('👋', style: TextStyle(fontSize: 18)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () {},
          icon: const Icon(Iconsax.notification, color: Color(0xFF222222)),
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final UserEntity user;
  final bool showBalances;
  final VoidCallback onToggleVisibility;

  const _BalanceCard({
    required this.user,
    required this.showBalances,
    required this.onToggleVisibility,
  });

  String _amount(double value, String currency) {
    if (!showBalances) return '*****';
    return '${value.toStringAsFixed(2)} $currency';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 19, 14, 18),
      color: const Color(0xFFE21B2D),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Main Balance',
                  style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 40,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Iconsax.add, size: 18),
                  label: const Text('Add Money'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF222222),
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Text(
                _amount(user.balance, user.currency),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Show balances',
                onPressed: onToggleVisibility,
                color: Colors.white,
                icon: Icon(showBalances ? Iconsax.eye : Iconsax.eye_slash, size: 20),
              ),
            ],
          ),
          const Divider(color: Colors.white38, height: 20),
          Row(
            children: [
              Expanded(child: _SubBalance(label: 'Reward Balance', value: _amount(0, user.currency))),
              Expanded(child: _SubBalance(label: 'Errif Balance', value: _amount(0, user.currency))),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubBalance extends StatelessWidget {
  final String label;
  final String value;

  const _SubBalance({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _ServiceGrid extends StatelessWidget {
  const _ServiceGrid();

  @override
  Widget build(BuildContext context) {
    const services = [
      _ServiceData('Merchant Payment', Iconsax.grid_2),
      _ServiceData('Bill Payment', Iconsax.bill),
      _ServiceData('Credit & Saving', Iconsax.wallet_money),
      _ServiceData('Transfer Money', Iconsax.arrow_swap_horizontal),
      _ServiceData('Airtime / Package', Iconsax.box),
      _ServiceData('More Services', Iconsax.element_3),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 112,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      itemBuilder: (_, index) => _ServiceCell(service: services[index]),
    );
  }
}

class _ServiceData {
  final String name;
  final IconData icon;

  const _ServiceData(this.name, this.icon);
}

class _ServiceCell extends StatelessWidget {
  final _ServiceData service;

  const _ServiceCell({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            service.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          Icon(service.icon, size: 27, color: const Color(0xFFE21B2D)),
        ],
      ),
    );
  }
}

class _TransactionList extends StatelessWidget {
  const _TransactionList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TransactionCard(
          initials: 'CBE',
          logoColor: Color(0xFF17884A),
          name: 'Aster Mequanint',
          subtitle: 'Bank',
          amount: '+222.00',
          amountColor: Color(0xFF17884A),
        ),
        SizedBox(height: 10),
        _TransactionCard(
          initials: 'M',
          logoColor: Color(0xFFE21B2D),
          name: 'Henok Chala',
          subtitle: 'Airtime',
          amount: '-1,020.00',
          amountColor: Color(0xFFE21B2D),
        ),
        SizedBox(height: 10),
        _TransactionCard(
          initials: 'M',
          logoColor: Color(0xFFE21B2D),
          name: 'Mekdes Tadesse',
          subtitle: 'Merchant Payment',
          amount: '-350.00',
          amountColor: Color(0xFFE21B2D),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String initials;
  final Color logoColor;
  final String name;
  final String subtitle;
  final String amount;
  final Color amountColor;

  const _TransactionCard({
    required this.initials,
    required this.logoColor,
    required this.name,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: logoColor,
            child: Text(
              initials,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Color(0xFF777777), fontSize: 12)),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(color: amountColor, fontSize: 14, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

