import 'package:flutter/material.dart';
import 'BasePage.dart';
import 'ReservationsPage.dart'; // Import the Reservations page

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the app's theme
    final textTheme = theme.textTheme; // Access text styles

    return BasePage(
      title: 'More',
      currentIndex: 4,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor, // Use theme's card color
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.person, size: 40, color: theme.primaryColor),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Abdelwahad',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Voir votre profil',
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16, color: theme.hintColor),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Options List
          ...[
            {'icon': Icons.settings, 'label': 'Préférence et confidentialité'},
            {'icon': Icons.info, 'label': 'Informations'},
            {
              'icon': Icons.calendar_today,
              'label': 'Mes Reservations',
              'onTap': () {
                // Navigate to Mes Reservations
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReservationsPage(),
                  ),
                );
              },
            },
            {
              'icon': Icons.account_balance_wallet,
              'label': 'Mon Solde',
              'subtitle': 'Gagner 50 points'
            },
            {'icon': Icons.photo, 'label': 'Galeries'},
            {'icon': Icons.help, 'label': 'Aide et assistance'},
            {'icon': Icons.logout, 'label': 'Déconnexion'},
          ].map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: theme.cardColor, // Use theme's card color
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                leading: Icon(item['icon'] as IconData,
                    color: theme.iconTheme.color),
                title: Text(
                  item['label'] as String,
                  style: textTheme.bodyMedium,
                ),
                subtitle: item.containsKey('subtitle')
                    ? Text(
                        item['subtitle'] as String,
                        style: textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      )
                    : null,
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 16, color: theme.hintColor),
                onTap: item['onTap'] as void Function()? ??
                    () {
                      // Default action for other items
                    },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
