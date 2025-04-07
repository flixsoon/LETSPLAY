import 'package:flutter/material.dart';
import 'BasePage.dart';
import 'ReservationsPage.dart'; // Import the Reservations page
import 'TeamCompletionPage.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the app's theme
    final textTheme = theme.textTheme; // Access text styles

    return BasePage(
      title: 'More',
      currentIndex: 4,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSectionTitle('Vos activités'),
            _buildMenuTile(
              context,
              icon: Icons.history,
              title: 'Historique des réservations',
              onTap: () {
                // Handle reservations history
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.favorite,
              title: 'Terrains favoris',
              onTap: () {
                // Handle favorite fields
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.group,
              title: 'Mes équipes',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TeamCompletionPage(
                      fieldId: '',
                      fieldTitle: '',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Paramètres du compte'),
            _buildMenuTile(
              context,
              icon: Icons.person,
              title: 'Profil',
              onTap: () {
                // Handle profile
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.notifications,
              title: 'Notifications',
              onTap: () {
                // Handle notifications
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.language,
              title: 'Langue',
              trailingText: 'Français',
              onTap: () {
                // Handle language
              },
            ),
            const SizedBox(height: 16),
            
            _buildSectionTitle('Support'),
            _buildMenuTile(
              context,
              icon: Icons.help,
              title: 'Aide',
              onTap: () {
                // Handle help
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.info,
              title: 'À propos',
              onTap: () {
                // Handle about
              },
            ),
            _buildMenuTile(
              context,
              icon: Icons.privacy_tip,
              title: 'Conditions d\'utilisation',
              onTap: () {
                // Handle terms
              },
            ),
            const SizedBox(height: 16),
            
            _buildMenuTile(
              context,
              icon: Icons.exit_to_app,
              title: 'Déconnexion',
              titleColor: Colors.red,
              onTap: () {
                // Handle logout
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Déconnexion'),
                    content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Perform logout action
                        },
                        child: const Text('Déconnecter'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? titleColor,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0B2133)),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailingText != null
            ? Text(
                trailingText,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              )
            : const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
