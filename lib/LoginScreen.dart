import 'package:cgcflutter/Auth_Service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final AuthService _authService = AuthService();
  bool _isSignedIn = false;
  String? _userName;
  String? _userEmail;
  String? _userPhotoUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        setState(() {
          _isSignedIn = true;
          _userName = currentUser.displayName;
          _userEmail = currentUser.email;
          _userPhotoUrl = currentUser.photoURL;
        });
      }
    } catch (e) {
      print('Error checking user: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        setState(() {
          _isSignedIn = true;
          _userName = user.displayName;
          _userEmail = user.email;
          _userPhotoUrl = user.photoURL;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome, ${user.displayName ?? "User"}!')),
        );
      }
    } catch (e) {
      print('Sign in error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signOut() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      await _authService.signOut();
      setState(() {
        _isSignedIn = false;
        _userName = null;
        _userEmail = null;
        _userPhotoUrl = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signed out successfully')),
      );
    } catch (e) {
      print('Sign out error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign out failed.')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Icon(
                _isSignedIn ? Icons.account_circle : Icons.login,
                size: 60,
                color: Colors.blue,
              ),
              SizedBox(height: 16),
              Text(
                _isSignedIn ? 'Signed In' : 'Sign In',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              if (_isSignedIn) ...[
                // User info
                CircleAvatar(
                  radius: 40,
                  backgroundImage: _userPhotoUrl != null
                      ? NetworkImage(_userPhotoUrl!)
                      : null,
                  child: _userPhotoUrl == null
                      ? Icon(Icons.person, size: 40)
                      : null,
                ),
                SizedBox(height: 12),
                Text(_userName ?? 'User',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                if (_userEmail != null)
                  Text(_userEmail!,
                      style: TextStyle(color: Colors.grey[600])),
                SizedBox(height: 20),
                // Sign out button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signOut,
                  icon: Icon(Icons.logout),
                  label: Text(_isLoading ? 'Signing out...' : 'Sign Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[100],
                    foregroundColor: Colors.red[700],
                    minimumSize: Size(double.infinity, 48),
                  ),
                ),
              ] else ...[
                // Sign in button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _signIn,
                  icon: Image.asset(
                    'assets/google_icon.png',
                    height: 24,
                    width: 24,
                    errorBuilder: (_, __, ___) => Icon(Icons.g_mobiledata),
                  ),
                  label: Text(_isLoading ? 'Signing in...' : 'Sign in with Google'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    minimumSize: Size(double.infinity, 48),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Secure authentication with Google',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}