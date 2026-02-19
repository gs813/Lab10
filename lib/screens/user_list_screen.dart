import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UserProvider>();

      // ✅ โหลดข้อมูลเฉพาะ admin
      if (provider.isAdmin) {
        provider.loadUsers();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    // 🔴 ถ้าไม่ใช่ admin ห้ามเข้า
    if (!provider.isAdmin) {
      return const Scaffold(
        body: Center(
          child: Text(
            "คุณไม่มีสิทธิ์เข้าถึงหน้านี้",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Users (Admin Only)"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                provider.isLoading ? null : () => provider.loadUsers(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const UserFormScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Add User"),
      ),
      body: Stack(
        children: [
          if (provider.users.isEmpty && !provider.isLoading)
            _emptyState()
          else
            ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.users.length,
              itemBuilder: (_, i) {
                final u = provider.users[i];
                return _userCard(context, u);
              },
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

  Widget _userCard(BuildContext context, user) {
    final provider = context.read<UserProvider>();
    final name =
        "${user.name.firstname} ${user.name.lastname}".trim();

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 24,
          child: Text(
            name.isNotEmpty ? name[0].toUpperCase() : "?",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          name.isEmpty ? "(No Name)" : name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${user.username} • ${user.email}"),
        trailing: Wrap(
          spacing: 6,
          children: [
            IconButton(
              icon:
                  const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                if (user.id == null) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UserFormScreen(editUser: user),
                  ),
                );
              },
            ),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                if (user.id == null) return;
                final confirm =
                    await _confirmDelete(context);
                if (confirm == true) {
                  await provider.removeUser(user.id!);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline,
              size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            "No Users Found",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text("Delete User"),
        content: const Text(
            "Are you sure you want to delete this user?"),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}
