import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'package:camera/camera.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart'; // Added for file handling

// ==========================================
// 1. CONFIGURATION & DATA MODELS
// ==========================================

class RealityItem {
  final String id;
  final String title;
  final String subtitle;
  final String bgImage;
  final Color themeColor;
  final Color particleColor;
  final String description;
  final String atmosphereType;
  final String actorImage; // CHANGED: From IconData to String (URL)

  const RealityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bgImage,
    required this.themeColor,
    required this.particleColor,
    required this.description,
    required this.atmosphereType,
    required this.actorImage,
  });
}

// FIXED: Stable Unsplash Images & PNG Actors
const List<RealityItem> realities = [
  RealityItem(
    id: 'dragon',
    title: "Dragon's Den",
    subtitle: "Ancient Era",
    bgImage: 'https://images.unsplash.com/photo-1595867352309-17a6411d73a6?q=80&w=800&auto=format&fit=crop',
    themeColor: Color(0xFFFF4E00),
    particleColor: Color(0xFFFFD700),
    description: "A realm of fire and scales where ancient beasts guard treasures beyond imagination.",
    atmosphereType: 'smoke',
    actorImage: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/6.png',
  ),
  RealityItem(
    id: 'cosmic',
    title: "Cosmic Voyage",
    subtitle: "Future Echo",
    bgImage: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=800&auto=format&fit=crop',
    themeColor: Color(0xFF0070F3),
    particleColor: Color(0xFF50E3C2),
    description: "Drifting through the stardust of a thousand dead suns, silence is your only companion.",
    atmosphereType: 'stars',
    actorImage: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/386.png',
  ),
  RealityItem(
    id: 'neon',
    title: "Cyber City",
    subtitle: "Digital Dream",
    bgImage: 'https://images.unsplash.com/photo-1555680202-c86f0e12f086?q=80&w=800&auto=format&fit=crop',
    themeColor: Color(0xFFBD00FF),
    particleColor: Color(0xFFFF00FF),
    description: "Neon lights reflect on wet pavement as the pulse of the city synchronizes with your heartbeat.",
    atmosphereType: 'glitch',
    actorImage: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/474.png',
  ),
  RealityItem(
    id: 'forest',
    title: "Spirit Woods",
    subtitle: "Nature's Whisper",
    bgImage: 'https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?q=80&w=800&auto=format&fit=crop',
    themeColor: Color(0xFF4ADE80),
    particleColor: Color(0xFF10B981),
    description: "Ancient trees guard secrets whispered by the wind, waiting for a soul quiet enough to listen.",
    atmosphereType: 'light_shafts',
    actorImage: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/251.png',
  ),
];

// ==========================================
// 2. SYSTEM SERVICES (HAPTICS)
// ==========================================

class NervousSystem {
  static void triggerHaptic(String type) async {
    try {
      bool? hasVib = await Vibration.hasVibrator();
      if (hasVib == true) {
        if (type == 'light') Vibration.vibrate(duration: 10);
        if (type == 'heavy') Vibration.vibrate(duration: 40);
        if (type == 'success') Vibration.vibrate(pattern: [0, 10, 50, 20]);
      } else {
        HapticFeedback.lightImpact();
      }
    } catch (e) {
      // Ignore emulator errors
    }
  }
}

// ==========================================
// 3. MAIN APP
// ==========================================

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0010),
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const JeeniApp());
}

class JeeniApp extends StatelessWidget {
  const JeeniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jeeni Vault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0010),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      home: const MainLayout(),
    );
  }
}

// ==========================================
// 4. MAIN LAYOUT (ORCHESTRATOR)
// ==========================================

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0; // 0: Portal, 1: Scanner, 2: Vault
  bool _isTransitioning = false;
  bool _introComplete = false;
  late RealityItem _currentReality;
  late StreamSubscription _intentSub;

  @override
  void initState() {
    super.initState();
    _currentReality = realities.first;
    
    // File Handling: Listen for .jeeni files
    _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
      if (value.isNotEmpty) {
         _handleSharedFile(value.first.path);
      }
    }, onError: (err) {
      debugPrint("getMediaStream error: $err");
    });

    // Check initial file
    ReceiveSharingIntent.instance.getInitialMedia().then((value) {
      if (value.isNotEmpty) {
        _handleSharedFile(value.first.path);
      }
    });
  }

  void _handleSharedFile(String path) {
      // In a real app, read the JSON content.
      // For demo, we pretend it's a Dragon file.
      setState(() {
          _currentReality = realities.first;
          _currentIndex = 0;
      });
      NervousSystem.triggerHaptic('success');
      
      // Trigger Portal Entry Animation
      Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (_,__,___) => ImmersivePlayer(reality: _currentReality),
            transitionDuration: const Duration(milliseconds: 800),
            transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
          )
      );
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  void _switchMode(int index) {
    if (_currentIndex == index) return;
    
    setState(() => _isTransitioning = true);
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _currentIndex = index;
        _isTransitioning = false;
      });
    });
  }

  void _selectReality(String id) {
    setState(() {
      _currentReality = realities.firstWhere((r) => r.id == id);
      _currentIndex = 0; // Return to portal
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_introComplete) {
      return CinematicIntro(onComplete: () => setState(() => _introComplete = true));
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0A0010),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. LIVING BACKGROUND (Global)
          const _GlobalBackground(),
          
          // 2. DYNAMIC ATMOSPHERE (Reacts to Theme)
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

          // 3. CONTENT SCREENS
          IndexedStack(
            index: _currentIndex,
            children: [
              // [0] PORTAL
              IgnorePointer(
                ignoring: _isTransitioning,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isTransitioning ? 0.0 : 1.0,
                  child: PortalView(
                    reality: _currentReality,
                    onWarp: () => Navigator.of(context).push(
                       PageRouteBuilder(
                         pageBuilder: (_,__,___) => ImmersivePlayer(reality: _currentReality),
                         transitionDuration: const Duration(milliseconds: 800),
                         transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
                       )
                    ),
                  ),
                ),
              ),
              
              // [1] SCANNER
              IgnorePointer(
                ignoring: _isTransitioning,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isTransitioning ? 0.0 : 1.0,
                  child: const ScannerView(),
                ),
              ),
              
              // [2] VAULT
              IgnorePointer(
                ignoring: _isTransitioning,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isTransitioning ? 0.0 : 1.0,
                  child: VaultView(onSelectReality: _selectReality),
                ),
              ),
            ],
          ),

          // 4. ORBITAL HUD (Bottom Nav)
          Positioned(
            bottom: 0, left: 0, right: 0,
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

// ==========================================
// 5. PORTAL VIEW (THE 4D CARD)
// ==========================================

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
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat(reverse: true);

    // FIXED: New gyroscopeEventStream
    _gyroSubscription = gyroscopeEventStream().listen((GyroscopeEvent event) {
      if (mounted) {
        setState(() {
          tiltX = (tiltX + event.y * 0.5).clamp(-0.2, 0.2);
          tiltY = (tiltY + event.x * 0.5).clamp(-0.2, 0.2);
        });
      }
    });
  }

  @override
  void dispose() {
    _gyroSubscription?.cancel();
    _pulseController.dispose();
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
            height: MediaQuery.of(context).size.width * 0.8 * (5/4),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // A. BACKLIGHT BLOOM
                Positioned.fill(
                  top: 20,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          // FIXED: withValues
                          color: widget.reality.themeColor.withValues(alpha: 0.2 + (_pulseController.value * 0.2)),
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: widget.reality.themeColor.withValues(alpha: 0.5),
                              blurRadius: 80,
                              spreadRadius: -10,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // B. THE CARD CONTAINER
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white.withValues(alpha: 0.1), Colors.black.withValues(alpha: 0.5)],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.reality.bgImage, 
                          fit: BoxFit.cover,
                          color: Colors.black.withValues(alpha: 0.4),
                          colorBlendMode: BlendMode.darken,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
                        ),
                        
                        const WormholeVortex(),
                        
                        Positioned(
                          bottom: 30, left: 20, right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.reality.subtitle.toUpperCase(),
                                style: GoogleFonts.rajdhani(
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold, 
                                  letterSpacing: 4,
                                  color: Colors.cyanAccent
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.reality.title.toUpperCase(),
                                style: GoogleFonts.cinzel(
                                  fontSize: 32, 
                                  fontWeight: FontWeight.w900, 
                                  color: Colors.white,
                                  shadows: [Shadow(color: widget.reality.themeColor, blurRadius: 20)]
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                // C. THE 4D BREAKOUT
                Positioned(
                  top: -50,
                  right: -20,
                  child: ActorWidget(reality: widget.reality),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActorWidget extends StatelessWidget {
  final RealityItem reality;
  const ActorWidget({super.key, required this.reality});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, 
      width: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: reality.themeColor.withValues(alpha: 0.4), blurRadius: 40)],
      ),
      child: Image.network(
        reality.actorImage,
        fit: BoxFit.contain,
      ).animate(onPlay: (c) => c.repeat(reverse: true))
       .moveY(begin: 0, end: -15, duration: 3.seconds, curve: Curves.easeInOut)
       .scale(begin: const Offset(1,1), end: const Offset(1.1, 1.1), duration: 3.seconds),
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
        _buildSpinningLayer(Colors.purpleAccent.withValues(alpha: 0.1), 20),
        _buildSpinningLayer(Colors.cyanAccent.withValues(alpha: 0.1), 15, reverse: true),
      ],
    );
  }

  Widget _buildSpinningLayer(Color color, int durationSec, {bool reverse = false}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: [color, Colors.transparent, color, Colors.transparent],
          stops: const [0.0, 0.5, 0.7, 1.0],
        ),
      ),
    ).animate(onPlay: (c) => c.repeat())
     .rotate(duration: Duration(seconds: durationSec), begin: 0, end: reverse ? -1 : 1);
  }
}

// ==========================================
// 6. SCANNER VIEW
// ==========================================

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  CameraController? _controller;
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras.first, ResolutionPreset.high, enableAudio: false);
        await _controller!.initialize();
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint("Camera error: $e");
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Feed
          if (_controller != null && _controller!.value.isInitialized)
             CameraPreview(_controller!)
          else 
             const Center(child: Text("INITIALIZING OPTICS...", style: TextStyle(color: Colors.cyan))),

          Container(color: Colors.cyan.withValues(alpha: 0.1)),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.grid_4x4, color: Colors.white54),
                      Text("SYSTEM: ONLINE", style: GoogleFonts.rajdhani(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                      const Icon(Icons.settings, color: Colors.white54),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 250, height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white30, width: 1),
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (c) => c.repeat(reverse: true))
                     .scale(begin: const Offset(1,1), end: const Offset(1.05, 1.05), duration: 1.seconds),
                  ),
                  GestureDetector(
                    onTapDown: (_) => setState(() => _isScanning = true),
                    onTapUp: (_) => setState(() => _isScanning = false),
                    child: AnimatedContainer(
                      duration: 200.ms,
                      width: _isScanning ? 90 : 80, height: _isScanning ? 90 : 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _isScanning ? Colors.redAccent : Colors.white, width: 4),
                        color: _isScanning ? Colors.red.withValues(alpha: 0.2) : Colors.transparent,
                      ),
                      child: const Icon(Icons.fingerprint, color: Colors.white, size: 40),
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

// ==========================================
// 7. VAULT VIEW (Memory Helix)
// ==========================================

class VaultView extends StatefulWidget {
  final Function(String) onSelectReality;
  const VaultView({super.key, required this.onSelectReality});
  @override
  State<VaultView> createState() => _VaultViewState();
}

class _VaultViewState extends State<VaultView> {
  final List<RealityItem> _vaultItems = [...realities, ...realities, ...realities, ...realities];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                "MEMORY HELIX",
                style: GoogleFonts.cinzel(fontSize: 24, color: Colors.white, letterSpacing: 4, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _vaultItems.length,
                itemBuilder: (context, index) {
                  final item = _vaultItems[index];
                  final double angle = index * 0.8;
                  final double xOffset = math.sin(angle) * 80;
                  final double scale = 0.8 + (math.cos(angle) * 0.2);
                  final double opacity = 0.5 + (math.cos(angle) * 0.5);

                  return Transform.translate(
                    offset: Offset(xOffset, 0),
                    child: Transform.scale(
                      scale: scale,
                      child: Opacity(
                        opacity: opacity.clamp(0.2, 1.0),
                        child: GestureDetector(
                          onTap: () => widget.onSelectReality(item.id),
                          child: Container(
                            height: 120,
                            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: item.themeColor),
                              boxShadow: [BoxShadow(color: item.themeColor.withValues(alpha: 0.3), blurRadius: 20)],
                            ),
                            child: Stack(
                                fit: StackFit.expand,
                                children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(item.bgImage, fit: BoxFit.cover, opacity: const AlwaysStoppedAnimation(0.7)),
                                    ),
                                    Center(child: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                                ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 8. ORBITAL HUD
// ==========================================

class OrbitalHud extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  const OrbitalHud({super.key, required this.selectedIndex, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    final modes = [Icons.auto_awesome_mosaic, Icons.remove_red_eye, Icons.memory];
    return Container(
      height: 100,
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(modes.length, (index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onItemSelected(index),
            child: AnimatedContainer(
              duration: 300.ms,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: isSelected ? 60 : 45,
              height: isSelected ? 60 : 45,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: isSelected ? Colors.cyanAccent : Colors.white24),
                boxShadow: isSelected ? [BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.3), blurRadius: 20)] : [],
              ),
              child: Icon(modes[index], color: Colors.white, size: isSelected ? 28 : 20),
            ),
          );
        }),
      ),
    );
  }
}

// ==========================================
// 9. HELPER WIDGETS
// ==========================================

class CinematicIntro extends StatelessWidget {
  final VoidCallback onComplete;
  const CinematicIntro({super.key, required this.onComplete});
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), onComplete);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 100, height: 2, color: Colors.cyan)
                .animate()
                .scaleX(begin: 0, end: 1, duration: 1.seconds, curve: Curves.easeOut)
                .then().fadeOut(),
            const SizedBox(height: 20),
            const Text("JEENI", style: TextStyle(color: Colors.white, letterSpacing: 10))
                .animate(delay: 1.seconds).fadeIn().shimmer(duration: 2.seconds),
          ],
        ),
      ),
    );
  }
}

class ImmersivePlayer extends StatelessWidget {
  final RealityItem reality;
  const ImmersivePlayer({super.key, required this.reality});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(reality.bgImage, fit: BoxFit.cover),
            Center(
              child: Text(reality.title, style: GoogleFonts.cinzel(fontSize: 40, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlobalBackground extends StatelessWidget {
  const _GlobalBackground({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF000000), Color(0xFF1A0024), Color(0xFF001214)],
        ),
      ),
    );
  }
}

class DynamicAtmosphere extends StatelessWidget {
  final String type;
  final Color color;
  const DynamicAtmosphere({super.key, required this.type, required this.color});
  @override
  Widget build(BuildContext context) => Container();
}

class PortalHoverParticles extends StatelessWidget {
  final Color color;
  const PortalHoverParticles({super.key, required this.color});
  @override
  Widget build(BuildContext context) => Container();
}