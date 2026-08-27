import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(BrainXpertsApp(isLoggedIn: isLoggedIn));
}

class BrainXpertsApp extends StatelessWidget {
  final bool isLoggedIn;
  const BrainXpertsApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainXperts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        primaryColor: const Color(0xFF2563EB),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF2563EB),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
        ),
      ),
      home: isLoggedIn ? const MainNavigationScreen() : const OnboardingScreen(),
    );
  }
}

// ---------------- ONBOARDING SCREEN ----------------
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'বিশাল কুইজ ভাণ্ডার',
      'desc': 'সাধারণ জ্ঞান, বিজ্ঞান, ইতিহাস এবং খেলাধুলার হাজারো কুইজ এখন এক জায়গায়।',
      'tag': 'জ্ঞানের নতুন দিগন্ত',
    },
    {
      'title': 'প্রতিদিনের নতুন চ্যালেঞ্জ',
      'desc': 'প্রতিদিন নতুন চ্যালেঞ্জে অংশ গ্রহণ করুন এবং আপনার মেধা যাচাই করুন নিয়মিত।',
      'tag': 'নিজেকে ছাড়িয়ে যান',
    },
    {
      'title': 'সহজ ও গোছানো প্রস্তুতি',
      'desc': 'যেকোনো পরীক্ষার প্রস্তুতির জন্য আমাদের বিশেষ টপিকগুলো আপনাকে রাখবে এগিয়ে।',
      'tag': 'ক্যারিয়ার গাইডলাইন',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                ),
                child: const Text('Skip', style: TextStyle(color: Colors.white70)),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemCount: _pages.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D9488),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school, size: 55, color: Colors.white),
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(_pages[i]['tag']!, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _pages[i]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _pages[i]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 14, color: Colors.white60),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? const Color(0xFF2563EB) : Colors.white24,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const AuthScreen()),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    _currentPage == _pages.length - 1 ? 'শুরু করুন ›' : 'পরবর্তী ›',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- AUTH SCREEN ----------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSignUp = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  void _submitAuth() async {
    String email = _emailController.text.trim();
    String pass = _passController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('অনুগ্রহ করে সঠিক ইমেইল অ্যাড্রেস লিখুন!')),
      );
      return;
    }

    if (pass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('পাসওয়ার্ড ন্যূনতম ৬ অক্ষরের হতে হবে!')),
      );
      return;
    }

    if (isSignUp && name.isEmpty) {
      name = email.split('@')[0];
    } else if (!isSignUp && name.isEmpty) {
      name = email.split('@')[0];
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    if (prefs.getInt('userCoins') == null) {
      await prefs.setInt('userCoins', 50);
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  void _googleSignInMock() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', 'Google User');
    await prefs.setString('userEmail', 'user.google@gmail.com');
    if (prefs.getInt('userCoins') == null) {
      await prefs.setInt('userCoins', 50);
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D9488),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                isSignUp ? 'অ্যাকাউন্ট তৈরি করুন' : 'স্বাগতম, লগইন করুন',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 30),
              if (isSignUp) ...[
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'পুরো নাম লিখুন',
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'ইমেইল অ্যাড্রেস',
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'পাসওয়ার্ড দিন (কমপক্ষে ৬ অক্ষর)',
                  filled: true,
                  fillColor: const Color(0xFF1E293B),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _submitAuth,
                  child: Text(
                    isSignUp ? 'সাইন আপ করুন' : 'লগইন করুন',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('অথবা', style: TextStyle(color: Colors.white60)),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.redAccent),
                  label: const Text('Continue with Google', style: TextStyle(color: Colors.white, fontSize: 15)),
                  onPressed: _googleSignInMock,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => setState(() => isSignUp = !isSignUp),
                child: Text(
                  isSignUp ? 'আগে থেকেই অ্যাকাউন্ট আছে? লগইন করুন' : 'নতুন অ্যাকাউন্ট তৈরি করতে চান? সাইন আপ করুন',
                  style: const TextStyle(color: Color(0xFF38BDF8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- MAIN NAVIGATION ----------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  String _userName = 'User';
  String _userEmail = 'user@gmail.com';
  int _userCoins = 50;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'BrainXpert';
      _userEmail = prefs.getString('userEmail') ?? 'user@gmail.com';
      _userCoins = prefs.getInt('userCoins') ?? 50;
    });
  }

  void _updateCoins(int newCoins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userCoins', newCoins);
    setState(() => _userCoins = newCoins);
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(userName: _userName, userCoins: _userCoins, onCoinAdded: () => _updateCoins(_userCoins + 5)),
      QuizScreen(userCoins: _userCoins, onDeductCoin: (c) => _updateCoins(_userCoins - c)),
      PurchaseScreen(userCoins: _userCoins, onBuyCoins: (c) => _updateCoins(_userCoins + c)),
      ProfileScreen(
        userName: _userName,
        userEmail: _userEmail,
        userCoins: _userCoins,
        onLogout: _logout,
        onNameUpdated: (newName) async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userName', newName);
          setState(() => _userName = newName);
        },
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (idx) => setState(() => _currentIndex = idx),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: const Color(0xFF38BDF8),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), label: 'কুইজ'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Purchase'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'প্রোফাইল'),
        ],
      ),
    );
  }
}

// ---------------- HOME SCREEN ----------------
class HomeScreen extends StatelessWidget {
  final String userName;
  final int userCoins;
  final VoidCallback onCoinAdded;

  const HomeScreen({super.key, required this.userName, required this.userCoins, required this.onCoinAdded});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.psychology, color: Color(0xFF38BDF8), size: 30),
                  SizedBox(width: 8),
                  Text('BrainXperts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.amber, width: 1.2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber, size: 18),
                    const SizedBox(width: 5),
                    Text('$userCoins', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF172554)]),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_fire_department, color: Colors.amber),
                        SizedBox(width: 6),
                        Text('Daily Staking & Streak', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(12)),
                      child: const Text('+5 Coins', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('প্রতিদিনের রিওয়ার্ড ক্লেইম করুন এবং বোনাস পান!', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                    onPressed: () {
                      onCoinAdded();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('+৫ কয়েন ক্লেইম হয়েছে!')),
                      );
                    },
                    icon: const Icon(Icons.card_giftcard, color: Colors.white),
                    label: const Text('Claim 5 Coins 🏆', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('হ্যালো, $userName', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('আজকের কুইজগুলো খেলে মেধা যাচাই করে নিন!', style: TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 20),
          const Text('Quiz Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCatCard(Icons.public, 'সাধারণ জ্ঞান'),
              _buildCatCard(Icons.sports_soccer, 'খেলাধুলা'),
              _buildCatCard(Icons.history_edu, 'ইতিহাস'),
              _buildCatCard(Icons.science, 'বিজ্ঞান'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCatCard(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: const Color(0xFF38BDF8)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}

// ---------------- QUIZ SCREEN ----------------
class QuizScreen extends StatelessWidget {
  final int userCoins;
  final Function(int) onDeductCoin;

  const QuizScreen({super.key, required this.userCoins, required this.onDeductCoin});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('All Quizzes', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildQuizTile(context, 'সাধারণ জ্ঞান', 20),
          _buildQuizTile(context, 'খেলাধুলা', 20),
          _buildQuizTile(context, 'ইতিহাসের পাতা', 20),
          _buildQuizTile(context, 'বিজ্ঞান ও প্রযুক্তি', 20),
        ],
      ),
    );
  }

  Widget _buildQuizTile(BuildContext context, String title, int cost) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('১০০+ প্রশ্নভাণ্ডার • $cost Coins', style: const TextStyle(color: Colors.white54)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (userCoins >= cost) {
            onDeductCoin(cost);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title কুইজ আনলক হয়েছে! ($cost কয়েন কাটা হয়েছে)')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('পর্যাপ্ত কয়েন নেই! Purchase থেকে কয়েন নিন।')),
            );
          }
        },
      ),
    );
  }
}

// ---------------- PURCHASE SCREEN ----------------
class PurchaseScreen extends StatelessWidget {
  final int userCoins;
  final Function(int) onBuyCoins;

  const PurchaseScreen({super.key, required this.userCoins, required this.onBuyCoins});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Premium Wallet', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Balance', style: TextStyle(color: Colors.white54, fontSize: 13)),
                    Row(
                      children: [
                        const Icon(Icons.monetization_on, color: Colors.amber, size: 24),
                        const SizedBox(width: 6),
                        Text('$userCoins', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.account_balance_wallet, size: 40, color: Color(0xFF38BDF8)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildCoinPack(context, 50, '\$0.51'),
          _buildCoinPack(context, 100, '\$1.01'),
          _buildCoinPack(context, 200, '\$2.01'),
          _buildCoinPack(context, 500, '\$5.01'),
        ],
      ),
    );
  }

  Widget _buildCoinPack(BuildContext context, int coins, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.monetization_on, color: Colors.amber, size: 30),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$coins Coins', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text(price, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
            onPressed: () {
              onBuyCoins(coins);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('+$coins কয়েন সফলভাবে কেনা হয়েছে!')),
              );
            },
            child: const Text('Buy Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ---------------- PROFILE SCREEN ----------------
class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final int userCoins;
  final VoidCallback onLogout;
  final Function(String) onNameUpdated;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userCoins,
    required this.onLogout,
    required this.onNameUpdated,
  });

  void _showEditNameDialog(BuildContext context) {
    final controller = TextEditingController(text: userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('নাম পরিবর্তন'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'নতুন নাম লিখুন'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('বাতিল')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onNameUpdated(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('সংরক্ষণ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('প্রোফাইল', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color(0xFF2563EB),
                child: Text(
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(userEmail, style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Stats', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ListTile(
              leading: const Icon(Icons.monetization_on, color: Colors.amber),
              title: const Text('Coins Balance'),
              trailing: Text('$userCoins', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Settings', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.manage_accounts, color: Color(0xFF38BDF8)),
                  title: const Text('Account Settings'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _showEditNameDialog(context),
                ),
                const Divider(height: 1, color: Colors.white10),
                ListTile(
                  leading: const Icon(Icons.privacy_tip, color: Color(0xFF38BDF8)),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final Uri url = Uri.parse('https://sites.google.com');
                    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {}
                  },
                ),
                const Divider(height: 1, color: Colors.white10),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  onTap: onLogout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
