import 'package:flutter/material.dart';
import 'BasePage.dart';
import 'TeamCompletionPage.dart';

class JouerPage extends StatelessWidget {
  const JouerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Jouer',
      currentIndex: 1, // Set the appropriate index for the footer navigation
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Comment voulez-vous jouer?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionCard(
                context,
                title: 'Complétion d\'équipe & Discussion entre joueurs',
                description: 'Trouvez des équipes qui cherchent des joueurs ou créez votre propre équipe',
                icon: Icons.group,
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
              _buildOptionCard(
                context,
                title: 'Organisation de Matchs',
                description: 'Créez un match et invitez d\'autres équipes à jouer',
                icon: Icons.sports_soccer,
                onTap: () {
                  // Handle match organization
                },
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                title: 'Tournois Locaux',
                description: 'Participez ou organisez des tournois dans votre région',
                icon: Icons.emoji_events,
                onTap: () {
                  // Handle local tournaments
                },
              ),
              const SizedBox(height: 16),
              _buildOptionCard(
                context,
                title: 'Entraînement & Cours',
                description: 'Trouvez des entraîneurs ou des cours pour améliorer vos compétences',
                icon: Icons.fitness_center,
                onTap: () {
                  // Handle training & courses
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B2133).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 36,
                  color: const Color(0xFF0B2133),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
