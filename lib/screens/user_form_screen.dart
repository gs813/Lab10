import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? editUser;

  const UserFormScreen({super.key, this.editUser});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  late final TextEditingController emailCtrl;
  late final TextEditingController usernameCtrl;
  late final TextEditingController passwordCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController firstCtrl;
  late final TextEditingController lastCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController streetCtrl;
  late final TextEditingController numberCtrl;
  late final TextEditingController zipCtrl;
  late final TextEditingController latCtrl;
  late final TextEditingController longCtrl;

  @override
  void initState() {
    super.initState();
    final u = widget.editUser;

    emailCtrl = TextEditingController(text: u?.email ?? '');
    usernameCtrl = TextEditingController(text: u?.username ?? '');
    passwordCtrl = TextEditingController(text: u?.password ?? '');
    phoneCtrl = TextEditingController(text: u?.phone ?? '');
    firstCtrl = TextEditingController(text: u?.name.firstname ?? '');
    lastCtrl = TextEditingController(text: u?.name.lastname ?? '');
    cityCtrl = TextEditingController(text: u?.address.city ?? '');
    streetCtrl = TextEditingController(text: u?.address.street ?? '');
    numberCtrl =
        TextEditingController(text: (u?.address.number ?? '').toString());
    zipCtrl = TextEditingController(text: u?.address.zipcode ?? '');
    latCtrl = TextEditingController(text: u?.address.geolocation.lat ?? '');
    longCtrl = TextEditingController(text: u?.address.geolocation.long ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      emailCtrl,
      usernameCtrl,
      passwordCtrl,
      phoneCtrl,
      firstCtrl,
      lastCtrl,
      cityCtrl,
      streetCtrl,
      numberCtrl,
      zipCtrl,
      latCtrl,
      longCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  UserModel _buildUser() {
    return UserModel(
      id: widget.editUser?.id,
      email: emailCtrl.text.trim(),
      username: usernameCtrl.text.trim(),
      password: passwordCtrl.text,
      phone: phoneCtrl.text.trim(),
      name: NameModel(
        firstname: firstCtrl.text.trim(),
        lastname: lastCtrl.text.trim(),
      ),
      address: AddressModel(
        city: cityCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        number: int.tryParse(numberCtrl.text) ?? 0,
        zipcode: zipCtrl.text.trim(),
        geolocation: GeoLocationModel(
          lat: latCtrl.text.trim(),
          long: longCtrl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final isEdit = widget.editUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit User" : "Create User"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildCardSection("Account", [
                    _modernField(emailCtrl, "Email"),
                    _modernField(usernameCtrl, "Username"),
                    _modernField(
                      passwordCtrl,
                      "Password",
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    _modernField(phoneCtrl, "Phone"),
                  ]),
                  _buildCardSection("Name", [
                    _modernField(firstCtrl, "First Name"),
                    _modernField(lastCtrl, "Last Name"),
                  ]),
                  _buildCardSection("Address", [
                    _modernField(cityCtrl, "City"),
                    _modernField(streetCtrl, "Street"),
                    _modernField(numberCtrl, "Number",
                        keyboardType: TextInputType.number),
                    _modernField(zipCtrl, "Zipcode"),
                  ]),
                  _buildCardSection("Geolocation", [
                    _modernField(latCtrl, "Latitude"),
                    _modernField(longCtrl, "Longitude"),
                  ]),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final user = _buildUser();
                              final p = context.read<UserProvider>();

                              if (isEdit) {
                                await p.editUser(widget.editUser!.id!, user);
                              } else {
                                await p.addUser(user);
                              }

                              if (!mounted) return;
                              if (p.error == null) {
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(p.error!)),
                                );
                              }
                            },
                      child: Text(isEdit ? "Save Changes" : "Create User"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (provider.isLoading)
            const ColoredBox(
              color: Colors.black26,
              child: Center(child: CircularProgressIndicator()),
            )
        ],
      ),
    );
  }

  Widget _buildCardSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _modernField(
    TextEditingController controller,
    String label, {
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: suffix,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
