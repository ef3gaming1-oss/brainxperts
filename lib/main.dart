import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: AuthWrapper(),
  ));
}

// Auth State Wrapper
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF070B19),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
          );
        }
        if (snapshot.hasData && snapshot.data != null) {
          return BottomNavHost(user: snapshot.data!);
        }
        return const IntroSlider();
      },
    );
  }
}

// Custom Owl Logo
class OwlAppLogo extends StatelessWidget {
  final double size;
  const OwlAppLogo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
          color: Color(0xFF00838F), shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.school,
              size: size * 0.45, color: const Color(0xFF070B19)),
          Positioned(
            bottom: size * 0.18,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _eye(size),
                SizedBox(width: size * 0.08),
                _eye(size),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _eye(double s) => Container(
        width: s * 0.22,
        height: s * 0.22,
        decoration: const BoxDecoration(
            color: Colors.white, shape: BoxShape.circle),
        child: Center(
          child: Container(
              width: s * 0.1,
              height: s * 0.1,
              decoration: const BoxDecoration(
                  color: Color(0xFF070B19), shape: BoxShape.circle)),
        ),
      );
}

// Custom Coin Badge
class CoinBadge extends StatelessWidget {
  final double size;
  const CoinBadge({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
            colors: [Colors.amberAccent, Colors.amber, Colors.orange]),
        border: Border.all(color: Colors.white70, width: 1),
      ),
      child: Center(
        child: Text('\$',
            style: TextStyle(
                color: Colors.brown.shade900,
                fontWeight: FontWeight.bold,
                fontSize: size * 0.6)),
      ),
    );
  }
}
// 1. Intro Slider
class IntroSlider extends StatefulWidget {
  const IntroSlider({super.key});
  @override
  State<IntroSlider> createState() => _IntroSliderState();
}

class _IntroSliderState extends State<IntroSlider> {
  final PageController _pageCtrl = PageController();
  int _curr = 0;

  final _slides = [
    {
      'tag': 'জ্ঞানের নতুন দিগন্ত',
      'title': 'বিশাল কুইজ ভাণ্ডার',
      'desc': 'সাধারণ জ্ঞান, বিজ্ঞান, ইতিহাস এবং খেলাধুলার হাজারো কুইজ এখন এক জায়গায়।'
    },
    {
      'tag': 'নিজেকে ছাড়িয়ে যান',
      'title': 'প্রতিদিনের নতুন চ্যালেঞ্জ',
      'desc': 'প্রতিদিন নতুন চ্যালেঞ্জে অংশ গ্রহণ করুন এবং আপনার মেধা যাচাই করুন নিয়মিত।'
    },
    {
      'tag': 'ক্যারিয়ার গাইডলাইন',
      'title': 'সহজ ও গোছানো প্রস্তুতি',
      'desc': 'যেকোনো পরীক্ষার প্রস্তুতির জন্য আমাদের বিশেষ ক্যাটাগরিগুলো আপনাকে দেবে পূর্ণাঙ্গ গাইডলাইন।'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_curr > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white70),
                      onPressed: () => _pageCtrl.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease),
                    )
                  else
                    const SizedBox(width: 48),
                  TextButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SignUpPage())),
                    child: const Text('Skip',
                        style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _curr = i),
                itemCount: 3,
                itemBuilder: (_, i) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const OwlAppLogo(size: 110),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                          color: Colors.white10,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(_slides[i]['tag']!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ),
                    const SizedBox(height: 14),
                    Text(_slides[i]['title']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(_slides[i]['desc']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 13,
                              height: 1.5)),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _curr == i ? 22 : 8,
                  height: 6,
                  decoration: BoxDecoration(
                      color: _curr == i
                          ? const Color(0xFF2563EB)
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_curr < 2) {
                      _pageCtrl.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.ease);
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SignUpPage()));
                    }
                  },
                  child: Text(_curr == 2 ? 'শুরু করুন ›' : 'পরবর্তী ›',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 2. Google Authentication Page
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isLoading = false;

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();

        if (!docSnapshot.exists) {
          await userDoc.set({
            'name': user.displayName ?? 'BrainXperts User',
            'email': user.email ?? '',
            'coins': 50,
            'spent': 0,
            'streakDay': 1,
            'lastClaimDate': '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('সাইন ইন ব্যর্থ হয়েছে: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const OwlAppLogo(size: 85),
                const SizedBox(height: 20),
                const Text('BrainXperts এ স্বাগতম',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('কুইজ খেলে মেধা যাচাই এবং রিওয়ার্ড অর্জন করুন',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 48),
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFF2563EB))
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          icon: const Icon(Icons.login, color: Colors.black87),
                          label: const Text('Continue with Google',
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          onPressed: _signInWithGoogle,
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
// 3. Navigation Host
class BottomNavHost extends StatefulWidget {
  final User user;
  const BottomNavHost({super.key, required this.user});

  @override
  State<BottomNavHost> createState() => _BottomNavHostState();
}

class _BottomNavHostState extends State<BottomNavHost> {
  int _tab = 0;

  bool _isToday(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return false;
    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";
    return dateStr == todayStr;
  }

  bool _isYesterday(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    final yestStr = "${yesterday.year}-${yesterday.month}-${yesterday.day}";
    return dateStr == yestStr;
  }

  int getRewardForDay(int day) {
    if (day == 30) return 500;
    if (day > 20) return 50;
    if (day > 10) return 20;
    return 5;
  }

  Future<bool> chargeCoins(int currentCoins, int currentSpent, int amt) async {
    if (currentCoins >= amt) {
      await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
        'coins': currentCoins - amt,
        'spent': currentSpent + amt,
      });
      return true;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('পর্যাপ্ত কয়েন নেই! কয়েন কিনুন।'),
          backgroundColor: Colors.redAccent),
    );
    return false;
  }

  Future<void> addBonusCoins(int currentCoins, int amt) async {
    await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
      'coins': currentCoins + amt,
    });
  }

  Future<void> claimDailyStreak(int currentCoins, int streakDay, String? lastClaimDate) async {
    if (_isToday(lastClaimDate)) return;

    final now = DateTime.now();
    final todayStr = "${now.year}-${now.month}-${now.day}";

    int nextStreak = 1;
    if (_isYesterday(lastClaimDate)) {
      nextStreak = streakDay >= 30 ? 1 : streakDay + 1;
    }

    int reward = getRewardForDay(nextStreak);

    await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({
      'coins': currentCoins + reward,
      'streakDay': nextStreak,
      'lastClaimDate': todayStr,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 অভিনন্দন! আপনি $reward কয়েন ক্লেইম করেছেন!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF070B19),
            body: Center(child: CircularProgressIndicator(color: Color(0xFF2563EB))),
          );
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        int userCoins = data['coins'] ?? 50;
        int spentCoins = data['spent'] ?? 0;
        String userName = data['name'] ?? widget.user.displayName ?? 'User';
        int streakDay = data['streakDay'] ?? 1;
        String lastClaimDate = data['lastClaimDate'] ?? '';
        bool isClaimedToday = _isToday(lastClaimDate);

        final screens = [
          HomeFeedView(
            coins: userCoins,
            userName: userName,
            onPlay: (amt) => chargeCoins(userCoins, spentCoins, amt),
            onBonus: (amt) => addBonusCoins(userCoins, amt),
            streakDay: streakDay,
            isClaimed: isClaimedToday,
            onClaimStreak: () => claimDailyStreak(userCoins, streakDay, lastClaimDate),
            getReward: getRewardForDay,
          ),
          QuizCategoryListView(
            onPlay: (amt) => chargeCoins(userCoins, spentCoins, amt),
            onBonus: (amt) => addBonusCoins(userCoins, amt),
          ),
          PurchaseGridView(
            coins: userCoins,
            onAdd: (amt) => addBonusCoins(userCoins, amt),
          ),
          ProfileFullView(
            user: widget.user,
            name: userName,
            balance: userCoins,
            spent: spentCoins,
            onNameChange: (newName) async {
              await FirebaseFirestore.instance.collection('users').doc(widget.user.uid).update({'name': newName});
            },
          ),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFF070B19),
          body: screens[_tab],
          bottomNavigationBar: NavigationBar(
            backgroundColor: const Color(0xFF0A1024),
            selectedIndex: _tab,
            onDestinationSelected: (i) => setState(() => _tab = i),
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_rounded), label: 'হোম'),
              NavigationDestination(
                  icon: Icon(Icons.lightbulb_outline_rounded), label: 'কুইজ'),
              NavigationDestination(
                  icon: Icon(Icons.account_balance_wallet_rounded),
                  label: 'Purchase'),
              NavigationDestination(
                  icon: Icon(Icons.person_rounded), label: 'প্রোফাইল'),
            ],
          ),
        );
      },
    );
  }
}
// ==================== TAB 1: Home Page ====================
class HomeFeedView extends StatelessWidget {
  final int coins;
  final String userName;
  final Future<bool> Function(int) onPlay;
  final Function(int) onBonus;
  final int streakDay;
  final bool isClaimed;
  final VoidCallback onClaimStreak;
  final int Function(int) getReward;

  const HomeFeedView({
    super.key,
    required this.coins,
    required this.userName,
    required this.onPlay,
    required this.onBonus,
    required this.streakDay,
    required this.isClaimed,
    required this.onClaimStreak,
    required this.getReward,
  });

  @override
  Widget build(BuildContext context) {
    int currentReward = getReward(streakDay);

    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            OwlAppLogo(size: 34),
            SizedBox(width: 8),
            Text('BrainXperts',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
                color: const Color(0xFF131D38),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0x80FFC107))),
            child: Row(
              children: [
                const CoinBadge(size: 18),
                const SizedBox(width: 6),
                Text('$coins',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E1B4B), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blueAccent.withAlpha(80)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded,
                            color: Colors.orangeAccent, size: 28),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Daily Staking & Streak',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16)),
                            Text('Day $streakDay of 30',
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('+$currentReward Coins',
                          style: const TextStyle(
                              color: Colors.amberAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: streakDay / 30,
                    minHeight: 8,
                    backgroundColor: Colors.white12,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'নিয়ম: 1-10 দিন 5 কয়েন, 11-20 দিন 20 কয়েন, 21-29 দিন 50 কয়েন, 30 তম দিনে 500 কয়েন জ্যাকপট!',
                  style: TextStyle(color: Colors.white60, fontSize: 11),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isClaimed
                          ? Colors.grey.shade700
                          : const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: isClaimed ? null : onClaimStreak,
                    child: Text(
                      isClaimed
                          ? 'আজকের কয়েন নেওয়া হয়েছে ✓'
                          : 'Claim $currentReward Coins 🎁',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF131D38),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('হ্যালো, $userName',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text('আজকের কুইজগুলো খেলে মেধা যাচাই করো (১০/১০ পেলে ১০ কয়েন বোনাস!)',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('Quiz Category',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _catItem(context, Icons.public, 'সাধারণ জ্ঞান', 'gk'),
              _catItem(context, Icons.sports_soccer, 'খেলাধুলা', 'sports'),
              _catItem(context, Icons.history_edu, 'ইতিহাস', 'history'),
              _catItem(context, Icons.science, 'বিজ্ঞান', 'science'),
            ],
          ),
          const SizedBox(height: 20),
          const Text('More Quizzes',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.95,
            children: [
              _posterCard(context, 'সাধারণ জ্ঞান কুইজ', Icons.public, Colors.blue, 'gk'),
              _posterCard(context, 'খেলাধুলা কুইজ', Icons.sports_soccer, Colors.orange, 'sports'),
              _posterCard(context, 'ইতিহাসের পাতা', Icons.history_edu, Colors.teal, 'history'),
              _posterCard(context, 'বিজ্ঞান ও প্রযুক্তি', Icons.science, Colors.purpleAccent, 'science'),
            ],
          )
        ],
      ),
    );
  }

  Widget _catItem(BuildContext ctx, IconData icon, String title, String catKey) =>
      InkWell(
        onTap: () => _openPlay(ctx, title, catKey),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xFF131D38),
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF3B82F6), size: 24),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      );

  Widget _posterCard(BuildContext ctx, String title, IconData icon, Color color, String catKey) =>
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: const Color(0xFF131D38),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withAlpha(77))),
        child: Column(
          mainAxisAlignment:指示Alignment.spaceBetween,
          children: [
            Icon(icon, size: 36, color: color),
            Text(title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    padding: EdgeInsets.zero),
                onPressed: () => _openPlay(ctx, title, catKey),
                child: const Text('Start',
                    style: TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      );

  void _openPlay(BuildContext ctx, String title, String catKey) async {
    bool ok = await onPlay(20);
    if (ok && ctx.mounted) {
      Navigator.push(
          ctx,
          MaterialPageRoute(
              builder: (_) => ActiveQuizPlayView(
                  title: title,
                  categoryKey: catKey,
                  onPerfectScore: () => onBonus(10))));
    }
  }
}

// ==================== TAB 2: Quiz List ====================
class QuizCategoryListView extends StatelessWidget {
  final Future<bool> Function(int) onPlay;
  final Function(int) onBonus;
  const QuizCategoryListView({super.key, required this.onPlay, required this.onBonus});

  @override
  Widget build(BuildContext context) {
    final list = [
      {'t': 'সাধারণ জ্ঞান', 'k': 'gk', 'd': '১০০+ প্রশ্নভাণ্ডার • ২০ Coins', 'i': Icons.public, 'col': Colors.blue},
      {'t': 'খেলাধুলা', 'k': 'sports', 'd': '১০০+ প্রশ্নভাণ্ডার • ২০ Coins', 'i': Icons.sports_soccer, 'col': Colors.orange},
      {'t': 'ইতিহাসের পাতা', 'k': 'history', 'd': '১০০+ প্রশ্নভাণ্ডার • ২০ Coins', 'i': Icons.history_edu, 'col': Colors.teal},
      {'t': 'বিজ্ঞান ও প্রযুক্তি', 'k': 'science', 'd': '১০০+ প্রশ্নভাণ্ডার • ২০ Coins', 'i': Icons.science, 'col': Colors.purple},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('All Quizzes', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        itemBuilder: (ctx, i) => Card(
          color: const Color(0xFF131D38),
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(list[i]['i'] as IconData, color: list[i]['col'] as Color),
            title: Text(list[i]['t'] as String,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(list[i]['d'] as String,
                style: const TextStyle(color: Colors.white54, fontSize: 12)),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white54),
            onTap: () async {
              bool ok = await onPlay(20);
              if (ok && ctx.mounted) {
                Navigator.push(
                    ctx,
                    MaterialPageRoute(
                        builder: (_) => ActiveQuizPlayView(
                            title: list[i]['t'] as String,
                            categoryKey: list[i]['k'] as String,
                            onPerfectScore: () => onBonus(10))));
              }
            },
          ),
        ),
      ),
    );
  }
}
// ==================== TAB 3: Purchase Shop (Premium Wallet) ====================
class PurchaseGridView extends StatelessWidget {
  final int coins;
  final Function(int) onAdd;

  const PurchaseGridView({super.key, required this.coins, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final packages = [
      {'c': 50, 'p': '\$0.51'},
      {'c': 100, 'p': '\$1.01'},
      {'c': 200, 'p': '\$2.01'},
      {'c': 300, 'p': '\$3.01'},
      {'c': 400, 'p': '\$4.01'},
      {'c': 500, 'p': '\$5.01'},
      {'c': 600, 'p': '\$6.01'},
      {'c': 1000, 'p': '\$10.01'},
      {'c': 250, 'p': '\$1.99'},
      {'c': 150, 'p': '\$1.00'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Premium Wallet', style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color(0xFF131D38),
                borderRadius: BorderRadius.circular(14)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Balance',
                        style: TextStyle(color: Colors.white54, fontSize: 12)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const CoinBadge(size: 24),
                        const SizedBox(width: 8),
                        Text('$coins',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
                const Icon(Icons.account_balance_wallet_outlined,
                    size: 40, color: Colors.white30),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.1),
            itemCount: packages.length,
            itemBuilder: (_, i) => Container(
              decoration: BoxDecoration(
                  color: const Color(0xFF131D38),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10)),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CoinBadge(size: 30),
                  const SizedBox(height: 6),
                  Text('${packages[i]['c']} Coins',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                  Text(packages[i]['p'] as String,
                      style: const TextStyle(color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 28,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB)),
                      onPressed: () {
                        onAdd(packages[i]['c'] as int);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('সফলভাবে ${packages[i]['c']} কয়েন যুক্ত হয়েছে!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Buy Now',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== TAB 4: Profile ====================
class ProfileFullView extends StatelessWidget {
  final User user;
  final String name;
  final int balance;
  final int spent;
  final Function(String) onNameChange;

  const ProfileFullView({
    super.key,
    required this.user,
    required this.name,
    required this.balance,
    required this.spent,
    required this.onNameChange,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('প্রোফাইল', style: TextStyle(color: Colors.white))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: const Color(0xFF2563EB),
                backgroundImage: user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                child: user.photoURL == null
                    ? const Icon(Icons.person, size: 36, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text(user.email ?? 'No email',
                        style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Stats', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 8),
          _statTile('Coins Balance', '$balance', Icons.monetization_on),
          _statTile('Total Coins Spent', '$spent', Icons.shopping_bag_outlined),
          const SizedBox(height: 16),
          const Text('Settings', style: TextStyle(color: Colors.white54, fontSize: 13)),
          const SizedBox(height: 8),
          _actionTile(context, Icons.manage_accounts, 'Account Settings', () {
            _showAccountEdit(context);
          }),
          _actionTile(context, Icons.help_outline, 'Help & Support', () {
            _showMsg(context, 'Help & Support',
                'যেকোনো প্রশ্ন বা সাহায্যের জন্য যোগাযোগ করুন:\n\nGmail:\nappbrainxperts01@gmail.com\n\nTelegram:\n@brainxperts');
          }),
          _actionTile(context, Icons.privacy_tip_outlined, 'Privacy Policy', () {
            _showPrivacyDialog(context);
          }),
          const SizedBox(height: 12),
          Card(
            color: const Color(0xFF131D38),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Logout',
                  style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
              onTap: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String title, String val, IconData icon) => Card(
        color: const Color(0xFF131D38),
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(icon, color: Colors.amber),
          title: Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          trailing: Text(val,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ),
      );

  Widget _actionTile(BuildContext ctx, IconData i, String title, VoidCallback tap) =>
      Card(
        color: const Color(0xFF131D38),
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: Icon(i, color: Colors.white70),
          title: Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          trailing: const Icon(Icons.arrow_forward_ios,
              size: 14, color: Colors.white54),
          onTap: tap,
        ),
      );

  void _showAccountEdit(BuildContext ctx) {
    final ctrl = TextEditingController(text: name);
    showDialog(
      context: ctx,
      builder: () => AlertDialog(
        backgroundColor: const Color(0xFF131D38),
        title: const Text('Account Settings', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: ctrl,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              labelText: 'নাম পরিবর্তন',
              labelStyle: TextStyle(color: Colors.white54)),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (ctrl.text.isNotEmpty) onNameChange(ctrl.text);
              Navigator.pop(ctx);
            },
            child: const Text('সংরক্ষণ করুন', style: TextStyle(color: Colors.blueAccent)),
          )
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext ctx) => showDialog(
        context: ctx,
        builder: () => AlertDialog(
          backgroundColor: const Color(0xFF131D38),
          title: const Row(
            children: [
              Icon(Icons.privacy_tip, color: Colors.blueAccent),
              SizedBox(width: 8),
              Text('Privacy Policy', style: TextStyle(color: Colors.white)),
            ],
          ),
          content: const SingleChildScrollView(
            child: Text(
              'BrainXperts ব্যবহারকারীদের তথ্যের সুরক্ষাকে সর্বোচ্চ অগ্রাধিকার দেয়।\n\n'
              '১. তথ্য সংগ্রহ: ব্যবহারকারীর প্রোফাইল ও পয়েন্ট ডাটাবেজে সুরক্ষিত থাকে।\n\n'
              '২. লেনদেন সুরক্ষা: ইন-অ্যাপ কয়েন ও রিওয়ার্ড নিরাপদ সার্ভারে সংরক্ষিত হয়।\n\n'
              '৩. তথ্যের গোপনীয়তা: কোনো ব্যক্তিগত তথ্য ৩য় পক্ষের কাছে বিক্রয় বা শেয়ার করা হয় না।\n\n'
              'যোগাযোগ:\nGmail: appbrainxperts01@gmail.com\nTelegram: @brainxperts',
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('সম্মত আছি', style: TextStyle(color: Colors.blueAccent)))
          ],
        ),
      );

  void _showMsg(BuildContext ctx, String t, String m) => showDialog(
        context: ctx,
        builder: () => AlertDialog(
          backgroundColor: const Color(0xFF131D38),
          title: Text(t, style: const TextStyle(color: Colors.white)),
          content: Text(m, style: const TextStyle(color: Colors.white70)),
        ),
      );
}
// ==================== কুইজ ইঞ্জিন ও প্রশ্নভাণ্ডার ====================
class ActiveQuizPlayView extends StatefulWidget {
  final String title;
  final String categoryKey;
  final VoidCallback onPerfectScore;

  const ActiveQuizPlayView({
    super.key,
    required this.title,
    required this.categoryKey,
    required this.onPerfectScore,
  });

  @override
  State<ActiveQuizPlayView> createState() => _ActiveQuizPlayViewState();
}

class _ActiveQuizPlayViewState extends State<ActiveQuizPlayView> {
  late List<Map<String, dynamic>> _activeQuestions;
  int _idx = 0;
  int _score = 0;
  int? _pick;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _pickNew10Questions();
  }

  void _pickNew10Questions() {
    final rand = Random();
    List<Map<String, dynamic>> raw = _getBigRealBank(widget.categoryKey);
    raw.shuffle(rand);

    List<Map<String, dynamic>> list = [];
    for (var item in raw.take(10)) {
      List<String> options = [item['c'] as String, ...(item['w'] as List<String>)];
      options.shuffle(rand);
      list.add({
        'q': '${list.length + 1}. ${item['q']}',
        'o': options,
        'a': options.indexOf(item['c'] as String)
      });
    }

    setState(() {
      _activeQuestions = list;
    });
  }

  List<Map<String, dynamic>> _getBigRealBank(String key) {
    List<Map<String, dynamic>> bank = [];

    if (key == 'gk') {
      final countriesCapitals = [
        ['জাপানের', 'টোকিও', 'সিউল', 'বেইজিং', 'ব্যাংকক'],
        ['ফ্রান্সের', 'প্যারিস', 'লন্ডন', 'রোম', 'মাদ্রিদ'],
        ['যুক্তরাজ্যের (UK)', 'লন্ডন', 'বার্লিন', 'প্যারিস', 'ডাবলিন'],
        ['যুক্তরাষ্ট্রের (USA)', 'ওয়াশিংটন ডিসি', 'নিউইয়র্ক', 'শিকাগো', 'লস অ্যাঞ্জেলেস'],
        ['রাশিয়ার', 'মস্কো', 'সেন্ট পিটার্সবার্গ', 'কিয়েভ', 'মিনস্ক'],
        ['ভারতের', 'নয়াদিল্লি', 'মুম্বাই', 'কলকাতা', 'চেন্নাই'],
        ['জার্মানির', 'বার্লিন', 'মিউনিখ', 'ফ্রাঙ্কফুর্ট', 'ভিয়েনা'],
        ['ইতালির', 'রোম', 'মিলান', 'ভেনিস', 'ফ্লোরেন্স'],
        ['কানাডার', 'অটোয়া', 'টরন্টো', 'ভ্যাঙ্কুভার', 'মন্ট্রিল'],
        ['অস্ট্রেলিয়ার', 'ক্যানবেরা', 'সিডনি', 'মেলবোর্ন', 'পার্থ'],
        ['চীনের', 'বেইজিং', 'সাংহাই', 'গুয়াংজু', 'হংকং'],
        ['সৌদি আরবের', 'রিয়াদ', 'জেদ্দা', 'মক্কা', 'মদিনা'],
        ['তুরস্কের', 'আঙ্কারা', 'ইস্তাম্বুল', 'ইজমির', 'আন্তালিয়া'],
        ['মিসরের', 'কায়রো', 'আলেকজান্দ্রিয়া', 'গিজা', 'লুক্সর'],
        ['ব্রাজিলের', 'ব্রাসিলিয়া', 'রিও ডি জেনিরো', 'সাঁও পাওলো', 'সালভাদর'],
        ['আর্জেন্টিনার', 'বুয়েনস আইরেস', 'রোজারিও', 'করডোবা', 'মেন্দোজা'],
        ['স্পেনের', 'মাদ্রিদ', 'বার্সেলোনা', 'সেভিল', 'ভ্যালেন্সিয়া'],
        ['দক্ষিণ আফ্রিকার', 'প্রিটোরিয়া', 'কেপ টাউন', 'ডারবান', 'জোহানেসবার্গ'],
        ['দক্ষিণ কোরিয়ার', 'সিউল', 'বুসান', 'ইনচন', 'ডেগু'],
        ['মালয়েশিয়ার', 'কুয়ালালামপুর', 'পেনাং', 'জোহর বাহরু', 'পুত্রজায়া'],
        ['সুইজারল্যান্ডের', 'বার্ন', 'জেনেভা', 'জুরিখ', 'বাসেল'],
        ['পাকিস্তানের', 'ইসলামাবাদ', 'করাচি', 'লাহোর', 'পেশোয়ার'],
        ['নেপালের', 'কাঠমান্ডু', 'পোখরা', 'ললিতপুর', 'বিরাটনগর'],
        ['ভুটানের', 'থিম্পু', 'পারো', 'ফুন্টশোলিং', 'পুনাখা'],
        ['শ্রীলঙ্কার', 'শ্রী জয়বর্ধনেপুরা কোট', 'কলম্বো', 'ক্যান্ডি', 'গালে'],
      ];

      for (var item in countriesCapitals) {
        bank.add({
          'q': '${item[0]} রাজধানীর নাম কী?',
          'c': item[1],
          'w': [item[2], item[3], item[4]]
        });
      }

      final nationalGK = [
        {'q': 'বাংলাদেশের জাতীয় স্মৃতিসৌধের স্থপতি কে?', 'c': 'সৈয়দ মাইনুল হোসেন', 'w': ['হামিদুর রহমান', 'এফ আর খান', 'শামসুল ওয়ারেশ']},
        {'q': 'সূর্যোদয়ের দেশ বলা হয় কোন দেশকে?', 'c': 'জাপান', 'w': ['নরওয়ে', 'চীন', 'নিউজিল্যান্ড']},
        {'q': 'পৃথিবীর দীর্ঘতম নদীর নাম কী?', 'c': 'নীলনদ', 'w': ['আমাজন', 'মিসিসিপি', 'পদ্মা']},
        {'q': 'আন্তর্জাতিক মাতৃভাষা দিবস কোন তারিখে পালিত হয়?', 'c': '২১ ফেব্রুয়ারি', 'w': ['২৬ মার্চ', '১৬ ডিসেম্বর', '১ মে']},
        {'q': 'হাজার হ্রদের দেশ বলা হয় কোন রাষ্ট্রকে?', 'c': 'ফিনল্যান্ড', 'w': ['কানাডা', 'সুইজারল্যান্ড', 'সুইডেন']},
        {'q': 'পৃথিবীর সর্বোচ্চ শৃঙ্গ মাউন্ট এভারেস্ট কোন দেশে?', 'c': 'নেপাল', 'w': ['ভারত', 'চীন', 'ভুটান']},
        {'q': 'আয়তনের দিক থেকে বিশ্বের বৃহত্তম দেশ কোনটি?', 'c': 'রাশিয়া', 'w': ['কানাডা', 'চীন', 'যুক্তরাষ্ট্র']},
        {'q': 'ইউরোপের একক অভিন্ন মুদ্রার নাম কী?', 'c': 'ইউরো', 'w': ['ডলার', 'পাউন্ড', 'ফ্রাঙ্ক']},
        {'q': 'পৃথিবীর ফুসফুস বলা হয় কোন বনকে?', 'c': 'আমাজন রেইনফরেস্ট', 'w': ['সুন্দরবন', 'কঙ্গো বন', 'তাইগা বন']},
        {'q': 'বাংলাদেশের একমাত্র প্রবাল দ্বীপ কোনটি?', 'c': 'সেন্টমার্টিন', 'w': ['হাতিয়া', 'সন্দ্বীপ', 'মহেশখালী']},
        {'q': 'নোবেল পুরস্কার প্রবর্তক আলফ্রেড নোবেল কোন দেশের?', 'c': 'সুইডেন', 'w': ['যুক্তরাষ্ট্র', 'জার্মানি', 'ফ্রান্স']},
        {'q': 'পৃথিবীর সবচেয়ে বড় মহাসাগরের নাম কী?', 'c': 'প্রশান্ত মহাসাগর', 'w': ['আটলান্টিক', 'ভারত মহাসাগর', 'উত্তর মহাসাগর']},
        {'q': 'বিশ্ব পরিবেশ দিবস কোন তারিখে পালিত হয়?', 'c': '৫ জুন', 'w': ['২২ এপ্রিল', '১ মে', '১০ ডিসেম্বর']},
        {'q': 'আন্তর্জাতিক মানবাধিকার দিবস কোন তারিখে?', 'c': '১০ ডিসেম্বর', 'w': ['৫ জুন', '১ মে', '২৪ অক্টোবর']},
        {'q': 'রেডক্রসের আন্তর্জাতিক সদর দপ্তর কোথায় অবস্থিত?', 'c': 'জেনেভা', 'w': ['নিউইয়র্ক', 'প্যারিস', 'ভিয়েনা']},
        {'q': 'বিশ্ব স্বাস্থ্য সংস্থা (WHO) এর সদর দপ্তর কোথায়?', 'c': 'জেনেভা', 'w': ['নিউইয়র্ক', 'ওয়াশিংটন', 'রোম']},
      ];
      bank.addAll(nationalGK);
    } else if (key == 'sports') {
      final sportsData = [
        {'q': 'বিশ্বকাপ ফুটবল প্রতি কত বছর পরপর অনুষ্ঠিত হয়?', 'c': '৪ বছর', 'w': ['২ বছর', '৩ বছর', '৫ বছর']},
        {'q': 'অলিম্পিক পতাকায় মোট কয়টি রঙের রিং থাকে?', 'c': '৫টি', 'w': ['৪টি', '৬টি', '৭টি']},
        {'q': 'ফুটবলে সরাসরি লাল কার্ড দেখলে কী শাস্তি দেওয়া হয়?', 'c': 'মাঠ ত্যাগ', 'w': ['১০ মি. বিরতি', 'হলুদ কার্ড', 'ওয়ার্নিং']},
        {'q': 'আন্তর্জাতিক ক্রিকেট পিচের আদর্শ দৈর্ঘ্য কত গজ?', 'c': '২২ গজ', 'w': ['২০ গজ', '২৪ গজ', '২৬ গজ']},
        {'q': 'ফুটবল খেলায় প্রতি দলে মাঠে কতজন খেলোয়াড় থাকে?', 'c': '১১ জন', 'w': ['৯ জন', '১০ জন', '১২ জন']},
        {'q': 'দাবা খেলায় বোর্ডের মোট কতটি ঘর থাকে?', 'c': '৬৪টি', 'w': ['৫৬টি', '৭২টি', '১০০টি']},
        {'q': 'ব্যাডমিন্টনে এক সেটে জয়ের জন্য কত পয়েন্ট প্রয়োজন?', 'c': '২১ পয়েন্ট', 'w': ['১৫ পয়েন্ট', '১৮ পয়েন্ট', '২৫ পয়েন্ট']},
        {'q': 'আন্তর্জাতিক ক্রিকেটের প্রধান নিয়ন্ত্রক সংস্থা কোনটি?', 'c': 'ICC', 'w': ['FIFA', 'IOC', 'NBA']},
        {'q': 'ফিফা (FIFA) এর সদর দপ্তর কোথায় অবস্থিত?', 'c': 'জুরিখ', 'w': ['প্যারিস', 'লন্ডন', 'মাদ্রিদ']},
        {'q': 'বাস্কেটবল খেলায় প্রতিটি দলের কতজন কোর্টে থাকে?', 'c': '৫ জন', 'w': ['৬ জন', '৭ জন', '৮ জন']},
        {'q': 'প্রথম টি-টোয়েন্টি বিশ্বকাপ কত সালে অনুষ্ঠিত হয়?', 'c': '২০০৭', 'w': ['২০০৫', '২০০৯', '২০১১']},
        {'q': 'ভলিবল খেলায় প্রতি দলে কতজন খেলোয়াড় থাকে?', 'c': '৬ জন', 'w': ['৫ জন', '৭ জন', '৮ জন']},
        {'q': 'ওয়ানডে ক্রিকেটে প্রথম ডাবল সেঞ্চুরি কে করেন?', 'c': 'শচীন টেন্ডুলকার', 'w': ['রোহিত শর্মা', 'শেহবাগ', 'ক্রিস গেইল']},
        {'q': '২০২২ সালের ফিফা বিশ্বকাপ চ্যাম্পিয়ন দেশ কোনটি?', 'c': 'আর্জেন্টিনা', 'w': ['ফ্রান্স', 'ব্রাজিল', 'জার্মানি']},
        {'q': 'সবচেয়ে বেশি বিশ্বকাপ ফুটবল জয়ী দেশ কোনটি?', 'c': 'ব্রাজিল', 'w': ['ইতালি', 'জার্মানি', 'আর্জেন্টিনা']},
        {'q': 'টেস্ট ক্রিকেটে সর্বোচ্চ ব্যক্তিগত রানের ইনিংস কার?', 'c': 'ব্রায়ান লারা (৪০০)', 'w': ['ডন ব্র্যাডম্যান', 'শচীন', 'বিরাট কোহলি']},
        {'q': 'হকি খেলায় প্রতি দলে কতজন খেলোয়াড় থাকে?', 'c': '১১ জন', 'w': ['৯ জন', '১০ জন', '১২ জন']},
        {'q': 'ক্রিকেটে এলবিডব্লিউ (LBW) এর পুরো অর্থ কী?', 'c': 'Leg Before Wicket', 'w': ['Leg Behind Wicket', 'Last Bat Wicket', 'None']},
        {'q': 'প্রথম বিশ্বকাপ ফুটবল কত সালে অনুষ্ঠিত হয়েছিল?', 'c': '১৯৩০', 'w': ['১৯২৮', '১৯৩২', '১৯৩৬']},
        {'q': '১ম ফুটবল বিশ্বকাপ চ্যাম্পিয়ন কোন দেশ ছিল?', 'c': 'উরুগুয়ে', 'w': ['আর্জেন্টিনা', 'ব্রাজিল', 'ইতালি']},
        {'q': 'আন্তর্জাতিক ক্রিকেটে ১০০টি সেঞ্চুরির মালিক কে?', 'c': 'শচীন টেন্ডুলকার', 'w': ['রিকি পন্টিং', 'বিরাট কোহলি', 'লিয়ন স্মিথ']},
        {'q': 'সান্তিয়াগো বার্নাব্যু কোন ফুটবল ক্লাবের স্টেডিয়াম?', 'c': 'রিয়াল মাদ্রিদ', 'w': ['বার্সেলোনা', 'ম্যানচেস্টার ইউনাইটেড', 'জুভেন্টাস']},
        {'q': 'লর্ডস ক্রিকেট গ্রাউন্ড কোন দেশে অবস্থিত?', 'c': 'ইংল্যান্ড', 'w': ['অস্ট্রেলিয়া', 'ভারত', 'নিউজিল্যান্ড']},
        {'q': 'আধুনিক অলিম্পিক গেমস প্রথম কোথায় শুরু হয়?', 'c': 'এথেন্স (গ্রিস)', 'w': ['প্যারিস', 'রোম', 'লন্ডন']},
        {'q': 'আন্তর্জাতিক ক্রিকেটে সর্বাধিক উইকেট শিকারী কে?', 'c': 'মুত্তিয়া মুরালিধরন', 'w': ['শেন ওয়ার্ন', 'অনিল কুম্বলে', 'জেমস অ্যান্ডারসন']},
      ];
      bank.addAll(sportsData);
    } else if (key == 'history') {
      final histData = [
        {'q': 'ঐতিহাসিক পলাশীর যুদ্ধ কত সালে সংঘটিত হয়েছিল?', 'c': '১৭৫৭', 'w': ['১৭৬৪', '১৮৫৭', '১৯৪৭']},
        {'q': 'প্রথম বিশ্বযুদ্ধ কোন সালে শুরু হয়েছিল?', 'c': '১৯১৪', 'w': ['১৯১২', '১৯১৮', '১৯৩৯']},
        {'q': 'দ্বিতীয় বিশ্বযুদ্ধ কত সালে সমাপ্ত হয়েছিল?', 'c': '১৯৪৫', 'w': ['১৯৪৩', '১৯৪৭', '১৯৫০']},
        {'q': 'তাজমহল ভারতের কোন নদীর তীরে অবস্থিত?', 'c': 'যমুনা নদী', 'w': ['গঙ্গা নদী', 'সিন্ধু নদী', 'নর্মদা নদী']},
        {'q': 'বাংলাদেশের সংবিধান কত সালে কার্যকর করা হয়?', 'c': '১৯৭২', 'w': ['১৯৭১', '১৯৭৩', '১৯৭৫']},
        {'q': 'ফরাসি বিপ্লব কোন শতাব্দীতে শুরু হয়েছিল?', 'c': '১৮ শতকে (১৭৮৯)', 'w': ['১৬ শতকে', '১৭ শতকে', '১৯ শতকে']},
        {'q': 'জাতিসংঘ কত সালে প্রতিষ্ঠিত হয়?', 'c': '১৯৪৫', 'w': ['১৯১৯', '১৯৩৯', '১৯৫০']},
        {'q': 'প্রাচীন হরপ্পা ও মহেঞ্জোদারো সভ্যতা কোন নদীর তীরে ছিল?', 'c': 'সিন্ধু নদী', 'w': ['গঙ্গা নদী', 'নীলনদ', 'ইউফ্রেটিস']},
        {'q': 'বার্লিন প্রাচীর কত সালে ভেঙে ফেলা হয়েছিল?', 'c': '১৯৮৯', 'w': ['১৯৮৫', '১৯৯১', '১৯৯৫']},
        {'q': 'যুক্তরাষ্ট্রের প্রথম রাষ্ট্রপতির নাম কী ছিল?', 'c': 'জর্জ ওয়াশিংটন', 'w': ['আব্রাহাম লিংকন', 'থমাস জেফারসন', 'জন অ্যাডামস']},
        {'q': 'পানিপথের তৃতীয় যুদ্ধ কত সালে হয়েছিল?', 'c': '১৭৬১', 'w': ['১৫২৬', '১৫৫৬', '১৮০৩']},
        {'q': 'প্রাচীন মিশরের রাজাদের কী নামে ডাকা হতো?', 'c': 'ফেরাউন', 'w': ['সম্রাট', 'সুলতান', 'সিজার']},
        {'q': 'মোগল সাম্রাজ্যের প্রতিষ্ঠাতা কে ছিলেন?', 'c': 'বাবর', 'w': ['আকবর', 'হুমায়ুন', 'শাহজাহান']},
        {'q': 'টাইটানিক জাহাজ কত সালে ডুবে যায়?', 'c': '১৯১২', 'w': ['১৯০৫', '১৯১৪', '১৯২০']},
        {'q': 'ঐতিহাসিক ছয় দফা দাবি বঙ্গবন্ধু কত সালে উত্থাপন করেন?', 'c': '১৯৬৬', 'w': ['১৯৫২', '১৯৬৯', '১৯৭১']},
        {'q': 'বঙ্গভঙ্গ কত সালে রদ করা হয়?', 'c': '১৯১১', 'w': ['১৯০৫', '১৯৪৭', '১৯১৯']},
        {'q': 'কলম্বাস কত সালে আমেরিকা আবিষ্কার করেন?', 'c': '১৪৯২', 'w': ['১৪৯৮', '১৫০০', '১৬০০']},
        {'q': 'যুক্তরাষ্ট্রের স্বাধীনতা ঘোষণা কত সালে গৃহীত হয়?', 'c': '১৭৭৬', 'w': ['১৭৮৩', '১৭৮৯', '১৮০০']},
        {'q': 'পানিপথের প্রথম যুদ্ধ কত সালে সংঘটিত হয়?', 'c': '১৫২৬', 'w': ['১৫৫৬', '১৭৬১', '১৫০০']},
        {'q': 'ভাষা আন্দোলনের ঐতিহাসিক ঘটনা কত সালে ঘটে?', 'c': '১৯৫২', 'w': ['১৯৪৭', '১৯৬৬', '১৯৭১']},
      ];
      bank.addAll(histData);
    } else {
      final sciData = [
        {'q': 'সৌরজগতের সবচেয়ে উত্তপ্ত গ্রহ কোনটি?', 'c': 'শুক্র (Venus)', 'w': ['বুধ', 'মঙ্গল', 'বৃহস্পতি']},
        {'q': 'মানবদেহের সবচেয়ে বড় অঙ্গ/গ্রন্থি কোনটি?', 'c': 'যকৃৎ (Liver)', 'w': ['অগ্ন্যাশয়', 'হৃদপিণ্ড', 'কিডনি']},
        {'q': 'বায়ুমণ্ডলে সর্বাধিক পরিমাণে কোন গ্যাসটি উপস্থিত?', 'c': 'নাইট্রোজেন (৭৮%)', 'w': ['অক্সিজেন', 'কার্বন ডাই অক্সাইড', 'আর্গন']},
        {'q': 'বিশুদ্ধ পানির রাসায়নিক সংকেত কোনটি?', 'c': 'H2O', 'w': ['CO2', 'O2', 'NaCl']},
        {'q': 'আলোর গতি প্রতি সেকেন্ডে প্রায় কত?', 'c': '৩ লক্ষ কিমি', 'w': ['১ লক্ষ কিমি', '২ লক্ষ কিমি', '৫ লক্ষ কিমি']},
        {'q': 'সূর্যের অভ্যন্তরে শক্তি উৎপাদনের মূল প্রক্রিয়া কোনটি?', 'c': 'নিউক্লিয়ার ফিউশন', 'w': ['নিউক্লিয়ার ফিশন', 'দহন', 'মহাকর্ষ']},
        {'q': 'মানবদেহের কোষে কত জোড়া ক্রোমোজোম থাকে?', 'c': '২৩ জোড়া (৪৬টি)', 'w': ['২২ জোড়া', '২৪ জোড়া', '২৫ জোড়া']},
        {'q': 'শব্দের বেগ সবচেয়ে দ্রুত কোন মাধ্যমে চলে?', 'c': 'কঠিন মাধ্যমে', 'w': ['তরল মাধ্যমে', 'বায়বীয় মাধ্যমে', 'শূন্যস্থানে']},
        {'q': 'ভিটামিন সি এর রাসায়নিক নাম কী?', 'c': 'অ্যাসকরবিক অ্যাসিড', 'w': ['সাইট্রিক অ্যাসিড', 'রেটিনল', 'থায়ামিন']},
        {'q': 'উদ্ভিদের পাতা সবুজ দেখানোর জন্য দায়ী কোনটি?', 'c': 'ক্লোরোফিল', 'w': ['ক্যারোটিন', 'জ্যান্থোফিল', 'হিমোগ্লোবিন']},
        {'q': 'কম্পিউটারের প্রধান মস্তিষ্ক বা ব্রেন কোনটি?', 'c': 'CPU', 'w': ['RAM', 'Hard Disk', 'GPU']},
        {'q': 'বায়ুমণ্ডলের ওজোন স্তর কোন ক্ষতিকর রশ্মি শোষণ করে?', 'c': 'অতিবেগুনি রশ্মি (UV)', 'w': ['ইনফ্রারেড', 'এক্স-রে', 'গামা-রে']},
        {'q': 'পেনিসিলিন অ্যান্টিবায়োটিক কে আবিষ্কার করেন?', 'c': 'আলেকজান্ডার ফ্লেমিং', 'w': ['আইনস্টাইন', 'নিউটন', 'ডারউইন']},
        {'q': 'মানবদেহের স্বাভাবিক তাপমাত্রা কত ফারেনহাইট?', 'c': '৯৮.৬°F', 'w': ['৯৬.৪°F', '১০০°F', '১০২°F']},
        {'q': 'রক্তে হিমোগ্লোবিনের মূল কাজ কী?', 'c': 'অক্সিজেন পরিবহন করা', 'w': ['খাদ্য তৈরি', 'রোগ দমন', 'রক্ত জমাট']},
        {'q': 'পরমাণুর নিউক্লিয়াসে কোন কোন কণা থাকে?', 'c': 'প্রোটন ও নিউট্রন', 'w': ['ইলেকট্রন ও প্রোটন', 'শুধু ইলেকট্রন', 'শুধু নিউট্রন']},
        {'q': 'মাধ্যাকর্ষণ সূত্র প্রথম কে আবিষ্কার করেন?', 'c': 'স্যার আইজ্যাক নিউটন', 'w': ['গ্যালিলিও', 'আইনস্টাইন', 'কেপলার']},
        {'q': 'বায়ুর চাপ পরিমাপক যন্ত্রের নাম কী?', 'c': 'ব্যারোমিটার', 'w': ['অ্যানিমোমিটার', 'হাইড্রোমিটার', 'সিসমোগ্রাফ']},
        {'q': 'হীরক ও গ্রাফাইট কোন মৌলিক পদার্থের রূপভেদ?', 'c': 'কার্বন', 'w': ['সিলিকন', 'সালফার', 'ফসফরাস']},
        {'q': 'কোন রক্ত গ্রুপকে সর্বজনীন দাতা বলা হয়?', 'c': 'O নেগেটিভ', 'w': ['A পজিটিভ', 'B পজিটিভ', 'AB পজিটিভ']},
      ];
      bank.addAll(sciData);
    }
    return bank;
  }

  void _tapOpt(int i) {
    if (_answered) return;

    setState(() {
      _pick = i;
      _answered = true;
      if (i == _activeQuestions[_idx]['a']) _score += 10;
    });

    Future.delayed(const Duration(milliseconds: 850), () {
      if (_idx < _activeQuestions.length - 1) {
        setState(() {
          _idx++;
          _pick = null;
          _answered = false;
        });
      } else {
        bool perfect = (_score == 100);
        if (perfect) {
          widget.onPerfectScore();
        }

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: () => AlertDialog(
            backgroundColor: const Color(0xFF131D38),
            title: Text(perfect ? 'অসাধারণ! ১০/১০ জ্যাকপট! 🎉' : 'কুইজ সমাপ্ত!',
                style: const TextStyle(color: Colors.white)),
            content: Text(
                perfect
                    ? 'আপনার অর্জিত স্কোর: $_score / ১০০\nআপনি বোনাস ১০ কয়েন পেয়েছেন!'
                    : 'আপনার অর্জিত স্কোর: $_score / ১০০',
                style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('মেনুতে যান', style: TextStyle(color: Colors.blueAccent)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB)),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _idx = 0;
                    _score = 0;
                    _pick = null;
                    _answered = false;
                  });
                  _pickNew10Questions();
                },
                child: const Text('আবার খেলুন (নতুন ১০টি)', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cur = _activeQuestions[_idx];
    final ans = cur['a'] as int;

    return Scaffold(
      backgroundColor: const Color(0xFF070B19),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(widget.title, style: const TextStyle(color: Colors.white))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('প্রশ্ন ${_idx + 1}/10 (র‍্যান্ডম)',
                style: const TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(cur['q'] as String,
                style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...(cur['o'] as List<String>).asMap().entries.map((e) {
              Color col = const Color(0xFF131D38);
              if (_answered) {
                if (e.key == ans) {
                  col = Colors.green.shade700;
                } else if (e.key == _pick) {
                  col = Colors.red.shade700;
                }
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: col,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  onPressed: () => _tapOpt(e.key),
                  child: Text(e.value,
                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
