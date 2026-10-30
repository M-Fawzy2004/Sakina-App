import 'package:equatable/equatable.dart';

/// Pure domain entity representing a quick-access spiritual portal card.
class MaladhPortalItem extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String badgeText;
  final bool isEmeraldBadge;

  const MaladhPortalItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    this.isEmeraldBadge = false,
  });

  @override
  List<Object?> get props => [id, title, subtitle, badgeText, isEmeraldBadge];
}

