import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:dadaroo/config/app_config.dart';
import 'package:dadaroo/models/user_profile.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/theme/app_theme.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  List<UserProfile>? _members;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() => _loading = true);
    final provider = context.read<AppProvider>();
    final members = await provider.getFamilyMembers();
    if (mounted) {
      setState(() {
        _members = members;
        _loading = false;
      });
    }
  }

  Future<void> _removeMember(UserProfile member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Remove ${member.name} from the family?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final provider = context.read<AppProvider>();
      await provider.removeFamilyMember(member.uid);
      _loadMembers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final familyGroup = provider.familyGroup;
    final isCreator = provider.userProfile?.uid == familyGroup?.createdBy;

    return Scaffold(
      appBar: AppBar(title: const Text('Family Members')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Invite code section
                  if (familyGroup != null) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Invite Family Members',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Share this code so family can join:',
                              style: TextStyle(
                                color: AppTheme.warmBrown.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                  ClipboardData(text: familyGroup.inviteCode),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Code copied!')),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.lightOrange,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppTheme.primaryOrange,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      familyGroup.inviteCode,
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 6,
                                        color: AppTheme.primaryOrange,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(Icons.copy,
                                        color: AppTheme.primaryOrange),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 150,
                              width: 150,
                              child: QrImageView(
                                data:
                                    '${appConfig.deepLinkScheme}://join/${familyGroup.inviteCode}',
                                version: QrVersions.auto,
                                size: 150,
                                eyeStyle: QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: AppTheme.darkBrown,
                                ),
                                dataModuleStyle: QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: AppTheme.darkBrown,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Members list
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Members (${_members?.length ?? 0})',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_members != null)
                    ...(_members!.map((member) {
                      final isOwner = member.uid == familyGroup?.createdBy;
                      final isSelf = member.uid == provider.userProfile?.uid;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.primaryOrange.withValues(alpha: 0.15),
                            child: Text(
                              member.role == UserRole.dad
                                  ? appConfig.parentEmoji
                                  : appConfig.familyMemberEmoji,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                member.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkBrown,
                                ),
                              ),
                              if (isOwner) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryOrange
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Owner',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.primaryOrange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                              if (isSelf) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '(you)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.warmBrown,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            member.role.displayName +
                                (member.isAnonymous ? '' : ' • ${member.email}'),
                            style: TextStyle(
                              color: AppTheme.warmBrown.withValues(alpha: 0.7),
                            ),
                          ),
                          trailing: isCreator && !isSelf && !isOwner
                              ? IconButton(
                                  icon: Icon(Icons.remove_circle_outline,
                                      color: Colors.red.shade400),
                                  onPressed: () => _removeMember(member),
                                )
                              : null,
                        ),
                      );
                    })),
                ],
              ),
            ),
    );
  }
}
