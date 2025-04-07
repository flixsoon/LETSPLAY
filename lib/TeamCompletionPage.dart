import 'package:flutter/material.dart';

class TeamCompletionPage extends StatefulWidget {
  final String fieldId;
  final String fieldTitle;

  const TeamCompletionPage({
    Key? key,
    required this.fieldId,
    required this.fieldTitle,
  }) : super(key: key);

  @override
  _TeamCompletionPageState createState() => _TeamCompletionPageState();
}

class _TeamCompletionPageState extends State<TeamCompletionPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _messageController = TextEditingController();
  bool _isJoined = false;
  bool _isTyping = false;
  int _notificationCount = 2; // Initial notification count
  
  // Sample data for teams needing players
  final List<Map<String, dynamic>> _teamsList = [
    {
      'id': '1',
      'name': 'FC Barcelona Fans',
      'location': 'Terrain Bettana',
      'date': '2025-04-10',
      'time': '18:00',
      'playersNeeded': 3,
      'skill': 'Intermediate',
      'creator': 'Mohammed',
      'members': ['Mohammed', 'Youssef', 'Amine'],
      'description': 'We play every Thursday. Looking for 3 more players for a full team. Friendly matches only.',
      'messages': [
        {'sender': 'Mohammed', 'text': 'Hello everyone, we need 3 more players for our match this Thursday!', 'time': '2 hours ago'},
        {'sender': 'Amine', 'text': 'I\'ll bring my friend Karim if that\'s okay', 'time': '1 hour ago'},
        {'sender': 'Mohammed', 'text': 'That would be great! We still need 2 more players then.', 'time': '45 min ago'},
      ]
    },
    {
      'id': '2',
      'name': 'Real Madrid Supporters',
      'location': 'Marina Football Club',
      'date': '2025-04-12',
      'time': '20:00',
      'playersNeeded': 2,
      'skill': 'Advanced',
      'creator': 'Omar',
      'members': ['Omar', 'Hassan', 'Rachid', 'Khalid'],
      'description': 'Competitive team looking for 2 skilled players. We play regularly on weekends.',
      'messages': [
        {'sender': 'Omar', 'text': 'We need two skilled players for Saturday\'s match', 'time': '3 hours ago'},
        {'sender': 'Khalid', 'text': 'What positions are you looking for?', 'time': '2 hours ago'},
        {'sender': 'Omar', 'text': 'We need a goalkeeper and a defender', 'time': '2 hours ago'},
      ]
    },
    {
      'id': '3',
      'name': 'Casual Football Enthusiasts',
      'location': 'Terrain Salé Medina',
      'date': '2025-04-15',
      'time': '17:00',
      'playersNeeded': 5,
      'skill': 'Beginner',
      'creator': 'Soufiane',
      'members': ['Soufiane', 'Hamza'],
      'description': 'Just for fun! We welcome players of all levels. Come join us for a friendly match.',
      'messages': [
        {'sender': 'Soufiane', 'text': 'Looking for players to join our casual game next week!', 'time': '1 day ago'},
        {'sender': 'Hamza', 'text': 'I\'m a beginner, is that okay?', 'time': '20 hours ago'},
        {'sender': 'Soufiane', 'text': 'Absolutely! Everyone is welcome!', 'time': '19 hours ago'},
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Simulate typing indicators periodically if joined
    if (_isJoined) {
      Future.delayed(const Duration(seconds: 15), _simulateTyping);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _joinTeam() {
    setState(() {
      _isJoined = !_isJoined;
    });
    
    if (_isJoined) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have joined the team!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _createTeam() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController teamNameController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        int playersNeeded = 1;
        String skillLevel = 'Intermediate';
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create a Team'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: teamNameController,
                      decoration: const InputDecoration(
                        labelText: 'Team Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Players Needed:'),
                    Slider(
                      value: playersNeeded.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: playersNeeded.toString(),
                      onChanged: (value) {
                        setState(() {
                          playersNeeded = value.round();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Skill Level:'),
                    DropdownButton<String>(
                      value: skillLevel,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
                        DropdownMenuItem(value: 'Intermediate', child: Text('Intermediate')),
                        DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          skillLevel = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      minLines: 3,
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (teamNameController.text.isNotEmpty) {
                      // Add new team logic would go here
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Team "${teamNameController.text}" created successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a team name'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B2133),
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          }
        );
      },
    );
  }
  
  void _sendMessage(int teamIndex) {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        _teamsList[teamIndex]['messages'].add({
          'sender': 'You',
          'text': _messageController.text,
          'time': 'Just now',
        });
        _messageController.clear();
      });
      
      // Simulate another team member responding shortly after
      if (_isJoined) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _teamsList[teamIndex]['messages'].add({
                'sender': _teamsList[teamIndex]['creator'],
                'text': 'Thanks for your message! Looking forward to seeing you at the match.',
                'time': 'Just now',
              });
            });
          }
        });
      }
    }
  }

  void _simulateTyping() {
    if (!mounted) return;
    
    setState(() {
      _isTyping = true;
    });
    
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        _teamsList[0]['messages'].add({
          'sender': _teamsList[0]['creator'],
          'text': 'Is everyone still available for our match this weekend?',
          'time': 'Just now',
        });
        _notificationCount++;
      });
    });
    
    // Schedule next typing simulation
    Future.delayed(const Duration(seconds: 30), _simulateTyping);
  }

  Widget _buildTeamStatusIndicator(Map<String, dynamic> team) {
    int playersNeeded = team['playersNeeded'];
    int currentPlayers = team['members'].length;
    
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircularProgressIndicator(
            value: currentPlayers / (currentPlayers + playersNeeded),
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            strokeWidth: 8,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Team completion status',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$currentPlayers players joined, $playersNeeded more needed',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B2133),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B2133),
        title: const Text('Team Completion & Chat'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  setState(() {
                    _notificationCount = 0;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications read'))
                  );
                },
              ),
              if (_notificationCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Find Team'),
            Tab(text: 'My Teams'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0B2133),
        onPressed: _createTeam,
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Find Team Tab
          _buildFindTeamTab(),
          
          // My Teams Tab
          _buildMyTeamsTab(),
        ],
      ),
    );
  }
  
  Widget _buildFindTeamTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _teamsList.length,
      itemBuilder: (context, index) {
        final team = _teamsList[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  team['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text('at ${team['location']}'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: team['skill'] == 'Beginner' 
                        ? Colors.green.shade100 
                        : team['skill'] == 'Intermediate' 
                            ? Colors.blue.shade100 
                            : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    team['skill'],
                    style: TextStyle(
                      color: team['skill'] == 'Beginner' 
                          ? Colors.green.shade800 
                          : team['skill'] == 'Intermediate' 
                              ? Colors.blue.shade800 
                              : Colors.red.shade800,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      '${team['date']} at ${team['time']}',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Need ${team['playersNeeded']} players',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  team['description'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildTeamStatusIndicator(team),
              ),
              ExpansionTile(
                title: Row(
                  children: [
                    const Text('Discussion'),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B2133),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${team['messages'].length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: const Text('Tap to join the conversation'),
                children: [
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: team['messages'].length,
                            itemBuilder: (context, messageIndex) {
                              final message = team['messages'][messageIndex];
                              bool isCurrentUser = message['sender'] == 'You';
                              bool isCreator = message['sender'] == team['creator'];
                              
                              return Align(
                                alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser 
                                        ? const Color(0xFF0B2133) 
                                        : isCreator 
                                            ? Colors.blue.shade50
                                            : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            message['sender'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: isCurrentUser 
                                                  ? Colors.white 
                                                  : isCreator 
                                                      ? Colors.blue.shade700
                                                      : Colors.black87,
                                            ),
                                          ),
                                          if (isCreator) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.star,
                                              size: 14,
                                              color: Colors.amber.shade700,
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        message['text'],
                                        style: TextStyle(
                                          color: isCurrentUser ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 12,
                                            color: isCurrentUser 
                                                ? Colors.white.withOpacity(0.7) 
                                                : Colors.grey.shade500,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            message['time'],
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isCurrentUser 
                                                  ? Colors.white.withOpacity(0.7) 
                                                  : Colors.grey.shade500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.emoji_emotions_outlined),
                                color: Colors.amber,
                                onPressed: () {
                                  // Show emoji picker
                                },
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  decoration: const InputDecoration(
                                    hintText: 'Write a message...',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                  ),
                                  maxLines: null,
                                  textCapitalization: TextCapitalization.sentences,
                                  onSubmitted: (_) => _sendMessage(index),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send_rounded),
                                color: const Color(0xFF0B2133),
                                onPressed: () => _sendMessage(index),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0B2133),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _joinTeam,
                    child: const Text(
                      'Join Team',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildMyTeamsTab() {
    if (!_isJoined) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group_off,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'You haven\'t joined any teams yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0B2133),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () {
                _tabController.animateTo(0);
              },
              child: const Text('Find a Team'),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 1,
      itemBuilder: (context, index) {
        final team = _teamsList[0]; // Just use the first team for example
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF0B2133),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  team['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          team['location'],
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          '${team['date']} at ${team['time']}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Team Members:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ...team['members'].map((member) => Chip(
                          label: Text(member),
                          backgroundColor: Colors.grey.shade200,
                        )),
                        const Chip(
                          label: Text('You'),
                          backgroundColor: Color(0xFF0B2133),
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Team Chat:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListView.builder(
                        itemCount: team['messages'].length,
                        itemBuilder: (context, messageIndex) {
                          final message = team['messages'][messageIndex];
                          bool isYou = message['sender'] == 'You';
                          return Align(
                            alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isYou ? const Color(0xFF0B2133) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['sender'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isYou ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message['text'],
                                    style: TextStyle(
                                      color: isYou ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    message['time'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isYou ? Colors.white.withOpacity(0.7) : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_isTyping) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                width: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      left: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade500,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade600,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade700,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${_teamsList[0]['creator']} is typing...',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Write a message...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: const Color(0xFF0B2133),
                          onPressed: () => _sendMessage(0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _joinTeam,
                    child: const Text(
                      'Leave Team',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 