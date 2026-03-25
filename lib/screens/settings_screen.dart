import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:provider/provider.dart';
import 'language_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Back Button
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),

                const SizedBox(height: 10),

                Text(
                  lang.t('settings_title'),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  lang.t('set_info'),
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                // CARD 1
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const Icon(Icons.person, size: 28),
                            const SizedBox(width: 10),
                            Text(
                              lang.t('profile_info'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                         lang.t('update_details'),
                          style: const TextStyle(color: Colors.black54),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          lang.t('name'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),

                        const SizedBox(height: 6),

                        TextField(
                          controller: TextEditingController(text: "Dapa"),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 16),

                         Text(
                          lang.t('email'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "dapa@email.com",
                          style: TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          lang.t('email_cannot_change'),
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // CARD 2
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                           const Icon(Icons.language, size: 28),
                           const SizedBox(width: 10),
                            Text(
                             lang.t('language_pref'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        Text(
                            lang.t('choose_language'),
                          style: const TextStyle(color: Colors.black54),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          lang.t('recent_language'),
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),

                        const SizedBox(height: 8),

                        DropdownButtonFormField<String>(
                          value: lang.currentLang,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text("English"),
                            ),
                            DropdownMenuItem(
                              value: 'id',
                              child: Text("Bahasa Indonesia"),
                            ),
                            DropdownMenuItem(
                              value: 'es',
                              child: Text("Español"),
                            ),
                            DropdownMenuItem(
                              value: 'ru',
                              child: Text("Русский язык"),
                            ),
                            DropdownMenuItem(
                              value: 'zh',
                              child: Text("中文"),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              lang.changeLanguage(value);
                            }
                          },
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            lang.t('note_language_change'),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // BUTTON ROW
                Row(
                  children: [

                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Changes saved (dummy)"),
                            ),
                          );
                        },
                        child: Text(
                          lang.t('save_changes'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Logout",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}