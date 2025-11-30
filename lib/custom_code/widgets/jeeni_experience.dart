// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/index.dart';
import '/flutter_flow/custom_functions.dart';

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:glassmorphism/glassmorphism.dart'; // Restored Glassmorphism

/// --- MAIN WIDGET WRAPPER ---
class JeeniExperience extends StatefulWidget {
  const JeeniExperience({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  final double? width;
  final double? height;

  @override
  _JeeniExperienceState createState() => _JeeniExperienceState();
}

class _JeeniExperienceState extends State<JeeniExperience> {
  @override
  Widget build(BuildContext context) {
    // Uses the exact dark theme properties from your file
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0010),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      child: const MainLayout(),
    );
  }
}

// --- 1. CONFIGURATION & DATA ---
class RealityItem {
  final String id;
  final String title;
  final String subtitle;
  final String bgImage;
  final Color themeColor;
  final Color particleColor;
  final String description;
  final String atmosphereType;

  const RealityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bgImage,
    required this.themeColor,
    required this.particleColor,
    required this.description,
    required this.atmosphereType,
  });
}

const List<RealityItem> realities = [
  RealityItem(
    id: 'dragon',
    title: "Dragon's Den",
    subtitle: "Ancient Era",
    bgImage:
        'https://images.unsplash.com/photo-1598556889429-05d4a1386ac9?q=80&w=1000',
    themeColor: Color(0xFFFF4E00),
    particleColor: Color(0xFFFFD700),
    description:
        "A realm of fire and scales where ancient beasts guard treasures beyond imagination.",
    atmosphereType: 'smoke',
  ),
  RealityItem(
    id: 'cosmic',
    title: "Cosmic Voyage",
    subtitle: "Future Echo",
    bgImage:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=1000',
    themeColor: Color(0xFF0070F3),
    particleColor: Color(0xFF50E3C2),
    description:
        "Drifting through the stardust of a thousand dead suns, silence is your only companion.",
    atmosphereType: 'stars',
  ),
  RealityItem(
    id: 'neon',
    title: "Cyber City",
    subtitle: "Digital Dream",
    bgImage:
        'https://images.unsplash.com/photo-1565626424177-85b30248f72c?q=80&w=1000',
    themeColor: Color(0xFFBD00FF),
    particleColor: Color(0xFFFF00FF),
    description:
        "Neon lights reflect on wet pavement as the pulse of the city synchronizes with your heartbeat.",
    atmosphereType: 'glitch',
  ),
  RealityItem(
    id: 'forest',
    title: "Spirit Woods",
    subtitle: "Nature's Whisper",
    bgImage:
        'https://images.unsplash.com/photo-1448375240586-dfd8f3793371?q=80&w=1000',
    themeColor: Color(0xFF4ADE80),
    particleColor: Color(0xFF10B981),
    description:
        "Ancient trees guard secrets whispered by the wind, waiting for a soul quiet enough to listen.",
    atmosphereType: 'light_shafts',
  ),
];

// --- 2. NERVOUS SYSTEM (Haptics) ---
class NervousSystem {
  static void triggerHaptic(String type) async {
    // Attempts to use device vibration, falls back safely if unavailable
    try {
      if (await Vibration.hasVibrator() ?? false) {
        if (type == 'light') Vibration.vibrate(duration: 5);
        if (type == 'heavy') Vibration.vibrate(duration: 25);
        if (type == 'success') Vibration.vibrate(pattern: [0, 10, 50, 20]);
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      HapticFeedback.lightImpact();
    }
  }

  static void playSound(String type) {
    // Sound placeholder
  }
}

// --- 3. MAIN LAYOUT ORCHESTRATOR ---
class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  bool _isTransitioning = false;
  String _selectedRealityId = 'dragon';
  bool _introComplete = false;

  late RealityItem _currentReality;

  @override
  void initState() {
    super.initState();
    _currentReality = realities.first;
  }

  void _switchMode(int index) {
    if (_currentIndex == index) return;

    setState(() => _isTransitioning = true);
    NervousSystem.playSound('whoosh');

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentIndex = index;
        _isTransitioning = false;
      });
    });
  }

  void _selectReality(String id) {
    setState(() {
      _selectedRealityId = id;
      _currentReality = realities.firstWhere((r) => r.id == id);
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_introComplete) {
      return CinematicIntro(
          onComplete: () => setState(() => _introComplete = true));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0010),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _GlobalBackground(),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1000),
            child: KeyedSubtree(
              key: ValueKey(_currentReality.id),
              child: DynamicAtmosphere(
                type: _currentReality.atmosphereType,
                color: _currentReality.themeColor,
              ),
            ),
          ),

          // Portal
          IgnorePointer(
            ignoring: _currentIndex != 0 || _isTransitioning,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _currentIndex == 0 && !_isTransitioning ? 1.0 : 0.0,
              child: PortalView(
                reality: _currentReality,
                onWarp: () => Navigator.of(context).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      ImmersivePlayer(reality: _currentReality),
                  transitionDuration: const Duration(milliseconds: 800),
                  transitionsBuilder: (_, a, __, c) =>
                      FadeTransition(opacity: a, child: c),
                )),
              ),
            ),
          ),

          // Scanner
          IgnorePointer(
            ignoring: _currentIndex != 1 || _isTransitioning,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _currentIndex == 1 && !_isTransitioning ? 1.0 : 0.0,
              child: const ScannerView(),
            ),
          ),

          // Vault
          IgnorePointer(
            ignoring: _currentIndex != 2 || _isTransitioning,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _currentIndex == 2 && !_isTransitioning ? 1.0 : 0.0,
              child: VaultView(onSelectReality: _selectReality),
            ),
          ),

          // HUD
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: OrbitalHud(
              selectedIndex: _currentIndex,
              onItemSelected: _switchMode,
            ),
          ),
        ],
      ),
    );
  }
}

// --- 4. PORTAL VIEW (WITH SENSORS) ---
class PortalView extends StatefulWidget {
  final RealityItem reality;
  final VoidCallback onWarp;

  const PortalView({super.key, required this.reality, required this.onWarp});

  @override
  State<PortalView> createState() => _PortalViewState();
}

class _PortalViewState extends State<PortalView> with TickerProviderStateMixin {
  double tiltX = 0;
  double tiltY = 0;
  StreamSubscription? _gyroSubscription;

  @override
  void initState() {
    super.initState();
    // Re-enabled Gyroscope for that real 3D feel
    try {
      _gyroSubscription = gyroscopeEvents.listen((GyroscopeEvent event) {
        if (mounted) {
          setState(() {
            tiltX = (tiltX + event.y * 0.5).clamp(-0.2, 0.2);
            tiltY = (tiltY + event.x * 0.5).clamp(-0.2, 0.2);
          });
        }
      });
    } catch (e) {
      print("Gyroscope not available");
    }
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          NervousSystem.triggerHaptic('heavy');
          widget.onWarp();
        },
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(tiltY)
            ..rotateY(tiltX),
          alignment: Alignment.center,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.8 * (5 / 4),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Glow
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.reality.themeColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: widget.reality.themeColor.withOpacity(0.5),
                          blurRadius: 60,
                          spreadRadius: -10,
                        )
                      ],
                    ),
                  ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.1, 1.1),
                      duration: 4.seconds),
                ),

                // Card Content with Glassmorphism Border
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.reality.bgImage,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.4),
                        colorBlendMode: BlendMode.darken,
                      ),
                      const WormholeVortex(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              Colors.transparent,
                              widget.reality.themeColor.withOpacity(0.4)
                            ],
                            stops: const [0.4, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child:
                      PortalHoverParticles(color: widget.reality.particleColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WormholeVortex extends StatelessWidget {
  const WormholeVortex({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildSpinningLayer(Colors.purpleAccent.withOpacity(0.2), 20),
        _buildSpinningLayer(Colors.cyanAccent.withOpacity(0.2), 15,
            reverse: true),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 10)
            ],
          ),
        ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.2, 1.2),
            duration: 2.seconds),
      ],
    );
  }

  Widget _buildSpinningLayer(Color color, int durationSec,
      {bool reverse = false}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: [color, Colors.transparent, color, Colors.transparent],
          stops: const [0.0, 0.5, 0.7, 1.0],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat()).rotate(
        duration: Duration(seconds: durationSec),
        begin: 0,
        end: reverse ? -1 : 1);
  }
}

// --- 5. SCANNER VIEW ---
class ScannerView extends StatelessWidget {
  const ScannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1518544806308-c8f325cc77cc?q=80&w=1000',
            fit: BoxFit.cover,
            color: Colors.white.withOpacity(0.9),
            colorBlendMode: BlendMode.modulate,
          ),
        ),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border:
                  Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: Center(
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.white.withOpacity(0.8), blurRadius: 8)
                  ],
                ),
              ),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1.05, 1.05),
              duration: 2.seconds),
        ),
      ],
    );
  }
}

// --- 6. VAULT VIEW ---
class VaultView extends StatefulWidget {
  final Function(String) onSelectReality;
  const VaultView({super.key, required this.onSelectReality});

  @override
  State<VaultView> createState() => _VaultViewState();
}

class _VaultViewState extends State<VaultView> {
  final List<RealityItem> _vaultItems = [
    ...realities,
    ...realities,
    ...realities,
    ...realities,
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black, Colors.transparent, Colors.black],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                padding: const EdgeInsets.only(top: 60, bottom: 20),
                alignment: Alignment.center,
                child: Text(
                  "MEMORY HELIX",
                  style: GoogleFonts.cinzel(
                      fontSize: 24, color: Colors.white, letterSpacing: 4),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          top: 120,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 150),
            child: SizedBox(
              height: _vaultItems.length * 120.0 + 200,
              child: Stack(
                clipBehavior: Clip.none,
                children: List.generate(_vaultItems.length, (index) {
                  final item = _vaultItems[index];
                  final double yPos = index * 120.0;
                  final double angle = index * 0.5;
                  final double phase = (index % 2 == 0) ? 0 : math.pi;
                  final double xOffset = math.sin(angle + phase) * 100.0;
                  final double depth = math.cos(angle + phase);
                  final double scale = 0.7 + ((depth + 1) / 2) * 0.4;
                  final double opacity = 0.4 + ((depth + 1) / 2) * 0.6;

                  return Positioned(
                    top: yPos,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(xOffset, 0),
                        child: Transform.scale(
                          scale: scale,
                          child: Opacity(
                            opacity: opacity,
                            child: GestureDetector(
                              onTap: () {
                                NervousSystem.triggerHaptic('success');
                                widget.onSelectReality(item.id);
                              },
                              child: _buildCrystalNode(item),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCrystalNode(RealityItem item) {
    // Glassmorphism Crystal
    return GlassmorphicContainer(
      width: 140,
      height: 140,
      borderRadius: 40,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white.withOpacity(0.5), Colors.white.withOpacity(0.1)],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(item.bgImage,
              fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.7)),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20)),
              child: Text(item.title.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 7. ORBITAL HUD ---
class OrbitalHud extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const OrbitalHud(
      {super.key, required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final modes = [
      {'icon': Icons.auto_awesome_mosaic, 'label': 'PORTAL'},
      {'icon': Icons.radio_button_checked, 'label': 'SCANNER'},
      {'icon': Icons.memory, 'label': 'VAULT'},
    ];

    return Container(
      height: 120,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(modes.length, (index) {
          final isSelected = selectedIndex == index;
          final mode = modes[index];
          final double yOffset = (index == 1) ? 0.0 : -20.0;

          return GestureDetector(
            onTap: () {
              NervousSystem.triggerHaptic('heavy');
              onItemSelected(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              transform: Matrix4.identity()
                ..translate(0.0, yOffset)
                ..scale(isSelected ? 1.1 : 0.9),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.5),
                      border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.2),
                          width: isSelected ? 2 : 1),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.4),
                                  blurRadius: 20)
                            ]
                          : [],
                    ),
                    child: Icon(mode['icon'] as IconData,
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        size: 28),
                  ),
                  const SizedBox(height: 8),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Text(mode['label'] as String,
                        style: GoogleFonts.rajdhani(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// --- 8. IMMERSIVE PLAYER ---
class ImmersivePlayer extends StatefulWidget {
  final RealityItem reality;
  const ImmersivePlayer({super.key, required this.reality});

  @override
  State<ImmersivePlayer> createState() => _ImmersivePlayerState();
}

class _ImmersivePlayerState extends State<ImmersivePlayer> {
  double _exitProgress = 0.0;
  Timer? _exitTimer;

  void _startExit() {
    _exitTimer = Timer.periodic(const Duration(milliseconds: 20), (timer) {
      setState(() {
        _exitProgress += 0.02;
      });
      if (_exitProgress >= 1.0) {
        timer.cancel();
        NervousSystem.triggerHaptic('success');
        Navigator.pop(context);
      }
    });
  }

  void _cancelExit() {
    _exitTimer?.cancel();
    setState(() => _exitProgress = 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPressStart: (_) => _startExit(),
        onLongPressEnd: (_) => _cancelExit(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(widget.reality.bgImage, fit: BoxFit.cover)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.1, 1.1),
                    duration: 20.seconds),
            if (_exitProgress > 0)
              Container(
                  decoration: BoxDecoration(
                      gradient: RadialGradient(colors: [
                Colors.transparent,
                Colors.black.withOpacity(_exitProgress)
              ], stops: [
                1.0 - _exitProgress,
                1.0
              ]))),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.reality.title.toUpperCase(),
                          style: GoogleFonts.cinzel(
                              fontSize: 40,
                              color: Colors.white,
                              fontWeight: FontWeight.bold))
                      .animate()
                      .fadeIn(duration: 2.seconds)
                      .scale(),
                  const SizedBox(height: 20),
                  Text("HOLD TO WAKE",
                      style: GoogleFonts.rajdhani(
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 9. HELPERS ---
class _GlobalBackground extends StatelessWidget {
  const _GlobalBackground({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
          Color(0xFF000000),
          Color(0xFF0A0010),
          Color(0xFF2D004F)
        ])));
  }
}

class DynamicAtmosphere extends StatelessWidget {
  final String type;
  final Color color;
  const DynamicAtmosphere({super.key, required this.type, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
            decoration: BoxDecoration(
                gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.5,
                    colors: [color.withOpacity(0.05), Colors.transparent])))
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.2, 1.2),
            duration: 10.seconds);
  }
}

class PortalHoverParticles extends StatelessWidget {
  final Color color;
  const PortalHoverParticles({super.key, required this.color});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(10, (index) {
        final random = math.Random(index);
        return Align(
          alignment: Alignment(
              random.nextDouble() * 2 - 1, random.nextDouble() * 2 - 1),
          child: Container(
                  width: 4,
                  height: 4,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle))
              .animate(onPlay: (c) => c.repeat())
              .fade(duration: 2.seconds)
              .moveY(begin: 0, end: -50, duration: 3.seconds),
        );
      }),
    );
  }
}

class CinematicIntro extends StatefulWidget {
  final VoidCallback onComplete;
  const CinematicIntro({super.key, required this.onComplete});
  @override
  State<CinematicIntro> createState() => _CinematicIntroState();
}

class _CinematicIntroState extends State<CinematicIntro> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), widget.onComplete);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 100, height: 2, color: Colors.cyan)
                .animate()
                .scaleX(
                    begin: 0, end: 1, duration: 500.ms, curve: Curves.easeOut)
                .then()
                .fadeOut(),
            const SizedBox(height: 20),
            Icon(Icons.auto_awesome_mosaic, color: Colors.white, size: 60)
                .animate(delay: 600.ms)
                .scale(
                    begin: const Offset(0, 0),
                    end: const Offset(1, 1),
                    curve: Curves.elasticOut)
                .then()
                .shake(),
          ],
        ),
      ),
    );
  }
}
