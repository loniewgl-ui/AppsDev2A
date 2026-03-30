import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
      onGenerateRoute: (settings) {
        return _createRoute(settings);
      },
    );
  }
}

// Custom Route with Slide and Fade Transition
Route<dynamic> _createRoute(RouteSettings settings) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) {
      Widget page;
      if (settings.name == '/detail') {
        final args = settings.arguments as Map<String, dynamic>;
        page = DetailPage(itemIndex: args['index'] as int);
      } else {
        page = const MainPage();
      }
      return page;
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  final List<Widget> _pages = [
    const HomePage(),
    const ProfilePage(),
    const NotificationsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation App'),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: const CustomDrawer(),
      body: ScaleTransition(
        scale: _scaleAnimation,
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),
                SizedBox(height: 10),
                Text(
                  'User Name',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'user@example.com',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _staggeredController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _staggeredController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Create staggered animations for each grid item
    _itemAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggeredController,
          curve: Interval(
            (index * 0.15).clamp(0.0, 1.0),
            ((index * 0.15) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _staggeredController.forward();
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Animated header with fade-in
          FadeInAnimation(
            duration: const Duration(milliseconds: 800),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome Home!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'This is your home page',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          // Staggered grid items
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: List.generate(
              6,
              (index) => StaggeredGridItem(
                animation: _itemAnimations[index],
                index: index,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StaggeredGridItem extends StatelessWidget {
  final Animation<double> animation;
  final int index;

  const StaggeredGridItem({
    super.key,
    required this.animation,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailPage(itemIndex: index),
              ),
            );
          },
          child: Hero(
            tag: 'grid_item_$index',
            child: Card(
              elevation: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.primaries[index % Colors.primaries.length],
                      Colors.primaries[(index + 1) % Colors.primaries.length],
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    'Item ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Hero animation for profile avatar
            Hero(
              tag: 'profile_avatar',
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Flutter Developer',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  AnimatedProfileInfoCard(
                    title: 'Email',
                    subtitle: 'john.doe@example.com',
                    icon: Icons.email,
                    delay: 0,
                  ),
                  const SizedBox(height: 12),
                  AnimatedProfileInfoCard(
                    title: 'Phone',
                    subtitle: '+1 (555) 123-4567',
                    icon: Icons.phone,
                    delay: 100,
                  ),
                  const SizedBox(height: 12),
                  AnimatedProfileInfoCard(
                    title: 'Location',
                    subtitle: 'San Francisco, CA',
                    icon: Icons.location_on,
                    delay: 200,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedProfileInfoCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int delay;

  const AnimatedProfileInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.delay,
  });

  @override
  State<AnimatedProfileInfoCard> createState() =>
      _AnimatedProfileInfoCardState();
}

class _AnimatedProfileInfoCardState extends State<AnimatedProfileInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeSlideAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeSlideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(
      Duration(milliseconds: widget.delay),
      () => _controller.forward(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeSlideAnimation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(-0.5, 0), end: Offset.zero)
            .animate(_fadeSlideAnimation),
        child: MouseRegion(
          onEnter: (_) {
            setState(() => _isHovered = true);
          },
          onExit: (_) {
            setState(() => _isHovered = false);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()
              ..translate(_isHovered ? 8.0 : 0.0),
            child: Card(
              elevation: _isHovered ? 8 : 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
  late AnimationController _staggeredController;
  late List<Animation<double>> _notificationAnimations;

  @override
  void initState() {
    super.initState();
    _staggeredController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Create staggered animations for notifications
    _notificationAnimations = List.generate(
      8,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _staggeredController,
          curve: Interval(
            (index * 0.12).clamp(0.0, 1.0),
            ((index * 0.12) + 0.35).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    _staggeredController.forward();
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return AnimatedNotificationTile(
          animation: _notificationAnimations[index],
          index: index,
        );
      },
    );
  }
}

class AnimatedNotificationTile extends StatefulWidget {
  final Animation<double> animation;
  final int index;

  const AnimatedNotificationTile({
    super.key,
    required this.animation,
    required this.index,
  });

  @override
  State<AnimatedNotificationTile> createState() =>
      _AnimatedNotificationTileState();
}

class _AnimatedNotificationTileState extends State<AnimatedNotificationTile> {
  bool _isRead = false;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(widget.animation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            color: _isRead ? Colors.grey.shade100 : Colors.transparent,
            child: Card(
              child: InkWell(
                onTap: () {
                  setState(() => _isRead = true);
                },
                child: ListTile(
                  leading: Hero(
                    tag: 'notification_${widget.index}',
                    child: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primary,
                      child: Icon(
                        _getNotificationIcon(widget.index),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  title: Text(
                    'Notification ${widget.index + 1}',
                    style: TextStyle(
                      fontWeight:
                          _isRead ? FontWeight.normal : FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(_getNotificationText(widget.index)),
                  trailing: const Text(
                    'Now',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(int index) {
    switch (index % 4) {
      case 0:
        return Icons.message;
      case 1:
        return Icons.favorite;
      case 2:
        return Icons.share;
      case 3:
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  String _getNotificationText(int index) {
    final texts = [
      'You have a new message',
      'Someone liked your post',
      'Your post was shared',
      'Action completed successfully',
    ];
    return texts[index % 4];
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'General',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Use dark theme'),
            value: _darkModeEnabled,
            onChanged: (value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Preferences',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_selectedLanguage),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'About',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          const ListTile(title: Text('App Version'), subtitle: Text('1.0.0')),
          const ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.open_in_new),
          ),
          const ListTile(
            title: Text('Terms of Service'),
            trailing: Icon(Icons.open_in_new),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: ['English', 'Spanish', 'French', 'German'].map((lang) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedLanguage = lang;
                    });
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    title: Text(lang),
                    leading: Radio<String>(
                      value: lang,
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

// Detail Page with Hero animation
class DetailPage extends StatefulWidget {
  final int itemIndex;

  const DetailPage({super.key, required this.itemIndex});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item ${widget.itemIndex + 1}'),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Hero animation for the item
              Hero(
                tag: 'grid_item_${widget.itemIndex}',
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.primaries[widget.itemIndex % Colors.primaries.length],
                        Colors.primaries[(widget.itemIndex + 1) % Colors.primaries.length],
                      ],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Item ${widget.itemIndex + 1}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details for Item ${widget.itemIndex + 1}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This is a detailed view with smooth animations. The Hero animation provides a beautiful transition from the grid to this detailed page.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable Fade In Animation Widget
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeIn,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: widget.curve),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
