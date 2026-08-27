import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // চেক করা ইউজার আগে থেকেই লগইন আছে কিনা
  final User? currentUser = FirebaseAuth.instance.currentUser;
  
  runApp(BrainXpertsApp(isLoggedIn: currentUser != null));
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

// ---------------- APP LOGO WIDGET ----------------
class AppBrandLogo extends StatelessWidget {
  final double size;
  const AppBrandLogo({super.key, this.size = 85});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF0D9488)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ],
      ),
      child: Icon(Icons.psychology_rounded, size: size * 0.6, color: Colors.white),
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
      'desc': 'সাধারণ জ্ঞান, বিজ্ঞান, ইতিহাস এবং পরীক্ষার হাজারো কুইজ এখন এক জায়গায়।',
      'tag': 'জ্ঞানের নতুন দিগন্ত',
    },
    {
      'title': 'প্রতিদিনের নতুন চ্যালেঞ্জ',
      'desc': 'প্রতিদিন নতুন চ্যালেঞ্জে অংশ গ্রহণ করুন এবং রিওয়ার্ড পয়েন্ট জিতে নিন।',
      'tag': 'মেধা যাচাই',
    },
    {
      'title': 'সহজ ও সেরা প্রস্তুতি',
      'desc': 'নিজেকে এগিয়ে রাখতে BrainXperts-এ অংশ নিন আজই।',
      'tag': 'ক্যারিয়ার গাইড',
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
                        const AppBrandLogo(size: 100),
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
  bool isSignUp = false; // বাই-ডিফল্ট লগইন পেজ
  bool isLoading = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ইমেইল এবং পাসওয়ার্ড দিয়ে লগইন/রেজিস্ট্রেশন
  void _submitEmailAuth() async {
    String email = _emailController.text.trim();
    String pass = _passController.text.trim();
    String name = _nameController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showToast('অনুগ্রহ করে সঠিক ইমেইল অ্যাড্রেস লিখুন!');
      return;
    }

    if (pass.length < 6) {
      _showToast('পাসওয়ার্ড ন্যূনতম ৬ অক্ষরের হতে হবে!');
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential userCredential;
      if (isSignUp) {
        if (name.isEmpty) {
          name = email.split('@')[0];
        }
        userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
        await userCredential.user?.updateDisplayName(name);

        // Firestore এ নতুন ইউজারের ডাটা সেভ
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'photoUrl': '',
          'coins': 50,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        userCredential = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'অথেনটিকেশন ব্যর্থ হয়েছে!';
      if (e.code == 'user-not-found') msg = 'এই ইমেইলে কোনো অ্যাকাউন্ট নেই! আগে সাইন আপ করুন।';
      else if (e.code == 'wrong-password') msg = 'ভুল পাসওয়ার্ড দিয়েছেন!';
      else if (e.code == 'email-already-in-use') msg = 'এই ইমেইল দিয়ে আগেই অ্যাকাউন্ট খোলা আছে। লগইন করুন।';
      else if (e.code == 'invalid-email') msg = 'ইমেইল ফরম্যাট সঠিক নয়!';
      _showToast(msg);
    } catch (e) {
      _showToast('ত্রুটি: ${e.toString()}');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  // আসল Google Sign-In (ফোনের সব জিমেইল শো করবে)
  void _signInWithGoogle() async {
    setState(() => isLoading = true);
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // ইউজার ক্যানসেল করেছে
        setState(() => isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final docRef = _firestore.collection('users').doc(user.uid);
        final doc = await docRef.get();

        // ডাটাবেজে আগে না থাকলে নতুন ইউজার হিসেবে সেভ হবে
        if (!doc.exists) {
          await docRef.set({
            'name': user.displayName ?? user.email?.split('@')[0] ?? 'User',
            'email': user.email ?? '',
            'photoUrl': user.photoURL ?? '',
            'coins': 50,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        );
      }
    } catch (e) {
      _showToast('গুগল লগইন ব্যর্থ হয়েছে! ইন্টারনেটের সংযোগ চেক করুন।');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showToast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AppBrandLogo(size: 80),
                const SizedBox(height: 16),
                Text(
                  isSignUp ? 'নতুন অ্যাকাউন্ট তৈরি করুন' : 'স্বাগতম! লগইন করুন',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 24),
                if (isSignUp) ...[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'আপনার পুরো নাম লিখুন',
                      prefixIcon: const Icon(Icons.person, color: Colors.white60),
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
                    prefixIcon: const Icon(Icons.email, color: Colors.white60),
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
                    hintText: 'পাসওয়ার্ড (ন্যূনতম ৬ অক্ষর)',
                    prefixIcon: const Icon(Icons.lock, color: Colors.white60),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isLoading ? null : _submitEmailAuth,
                    child: isLoading
                        ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            isSignUp ? 'অ্যাকাউন্ট খুলুন' : 'লগইন করুন',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('অথবা', style: TextStyle(color: Colors.white60, fontSize: 13)),
                    ),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.redAccent),
                    label: const Text('Continue with Google', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
                    onPressed: isLoading ? null : _signInWithGoogle,
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
  String _userName = '';
  String _userEmail = '';
  String _photoUrl = '';
  int _userCoins = 50;
  bool _isDataLoaded = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          setState(() {
            _userName = data['name'] ?? user.displayName ?? user.email?.split('@')[0] ?? 'User';
            _userEmail = data['email'] ?? user.email ?? '';
            _photoUrl = data['photoUrl'] ?? user.photoURL ?? '';
            _userCoins = data['coins'] ?? 50;
            _isDataLoaded = true;
          });
          return;
        }
      } catch (e) {
        debugPrint('Error loading firestore: $e');
      }

      // ফলব্যাক ডাটা
      setState(() {
        _userName = user.displayName ?? user.email?.split('@')[0] ?? 'User';
        _userEmail = user.email ?? '';
        _photoUrl = user.photoURL ?? '';
        _isDataLoaded = true;
      });
    }
  }

  void _updateCoins(int newCoins) async {
    setState(() => _userCoins = newCoins);
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({'coins': newCoins});
      } catch (e) {
        debugPrint('Firestore coin update error: $e');
      }
    }
  }

  void _logout() async {
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
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
    if (!_isDataLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
      );
    }

    final List<Widget> screens = [
      HomeScreen(
        userName: _userName,
        userCoins: _userCoins,
        onCoinAdded: () => _updateCoins(_userCoins + 5),
      ),
      QuizScreen(userCoins: _userCoins, onDeductCoin: (c) => _updateCoins(_userCoins - c)),
      PurchaseScreen(userCoins: _userCoins, onBuyCoins: (c) => _updateCoins(_userCoins + c)),
      ProfileScreen(
        userName: _userName,
        userEmail: _userEmail,
        photoUrl: _photoUrl,
        userCoins: _userCoins,
        onLogout: _logout,
        onNameUpdated: (newName) async {
          setState(() => _userName = newName);
          final User? user = _auth.currentUser;
          if (user != null) {
            await _firestore.collection('users').doc(user.uid).update({'name': newName});
          }
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

  const HomeScreen({
    super.key,
    required this.userName,
    required this.userCoins,
    required this.onCoinAdded,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AppBrandLogo(size: 38),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BrainXperts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('হ্যালো, $userName', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
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
          const SizedBox(height: 24),
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
                        const SnackBar(content: Text('+৫ কয়েন সফলভাবে যোগ হয়েছে!')),
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                    label: const Text('Claim Reward', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
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
    return const Center(
      child: Text('কুইজ সেকশন প্রস্তুত হচ্ছে...', style: TextStyle(fontSize: 16, color: Colors.white70)),
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
    return const Center(
      child: Text('কয়েন পারচেজ সেকশন প্রস্তুত হচ্ছে...', style: TextStyle(fontSize: 16, color: Colors.white70)),
    );
  }
}

// ---------------- PROFILE SCREEN ----------------
class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String photoUrl;
  final int userCoins;
  final VoidCallback onLogout;
  final Function(String) onNameUpdated;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.photoUrl,
    required this.userCoins,
    required this.onLogout,
    required this.onNameUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0xFF0D9488),
              backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
              child: photoUrl.isEmpty
                  ? Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text(userName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          Center(child: Text(userEmail, style: const TextStyle(color: Colors.white60, fontSize: 13))),
          const SizedBox(height: 24),
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            tileColor: const Color(0xFF1E293B),
            leading: const Icon(Icons.monetization_on, color: Colors.amber),
            title: const Text('মোট কয়েন ব্যালেন্স'),
            trailing: Text('$userCoins', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.85),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onLogout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('লগআউট করুন', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
