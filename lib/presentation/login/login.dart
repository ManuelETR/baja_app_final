import 'package:baja_app/dominio/user.dart';
import 'package:baja_app/presentation/login/sign.dart';
import 'package:baja_app/services/firebase_auth_service.dart';
import 'package:baja_app/widgets/login/form_container.dart';
import 'package:baja_app/widgets/login/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isSigning = false;
  final FirebaseAuthService _auth = FirebaseAuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndSignOut();
  }

  Future<void> _checkAndSignOut() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50), // Añadir espacio para evitar que el teclado cubra contenido
                Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/BBLogo.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Iniciar Sesión",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 48, 110),
                  ),
                ),
                const SizedBox(height: 30),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Correo Electrónico",
                  isPasswordField: false,
                ),
                const SizedBox(height: 10),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Contraseña",
                  isPasswordField: true,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: _signIn,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF053F93),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _isSigning
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Acceder",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _signInWithGoogle,
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Acceder con Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("¿No tienes una cuenta?"),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Regístrate",
                        style: TextStyle(
                          color: Color(0xFF053F93),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Añadir espacio para evitar el desbordamiento
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    setState(() {
      _isSigning = true;
    });

    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      // Autenticar al usuario
      User? user = await _auth.signInWithEmailAndPassword(email, password);

      if (user != null) {
        // Verificar si el documento del usuario existe en Firestore
        UserM? userProfile = await _auth.getUserProfile(user.uid);

        if (userProfile == null) {
          // Si el documento no existe, crearlo
          await _auth.createUserProfile(user.uid, user.email!);
        }

        showToast(message: "User is successfully signed in");

        // Navegar a la pantalla de inicio una vez autenticado y perfil creado/verificado
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/home");
        }
      } else {
        showToast(message: "Some error occurred");
      }
    } on FirebaseAuthException catch (e) {
      showToast(message: "Authentication error: ${e.message}");
    } on FirebaseException catch (e) {
      showToast(message: "Firestore error: ${e.message}");
    } catch (e) {
      showToast(message: "An unknown error occurred: $e");
    } finally {
      setState(() {
        _isSigning = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        User? user = userCredential.user;

        if (user != null) {
          // Check if the user document exists in Firestore
          UserM? userProfile = await _auth.getUserProfile(user.uid);

          if (userProfile == null) {
            // If the user document does not exist, create it
            await _auth.createUserProfile(user.uid, user.email!);
          }

          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, "/home");
        }
      }
    } catch (e) {
      showToast(message: "some error occurred $e");
    }
  }
}
