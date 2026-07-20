import 'package:flutter/material.dart';

class RoomType {
  final String id;
  final String name;
  final IconData icon;

  const RoomType({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const List<RoomType> allTypes = [
    RoomType(id: 'primary_suite', name: 'Primary Suite', icon: Icons.king_bed),
    RoomType(id: 'main_br', name: 'Main Br', icon: Icons.bed),
    RoomType(id: 'bath_1', name: 'Bath #1', icon: Icons.bathtub),
    RoomType(id: 'bath_2', name: 'Bath #2', icon: Icons.bathtub_outlined),
    RoomType(id: 'kitchen', name: 'Kitchen', icon: Icons.kitchen),
    RoomType(id: 'living_rm', name: 'Living Rm', icon: Icons.weekend),
    RoomType(id: 'dining_rm', name: 'Dining Rm', icon: Icons.dining),
    RoomType(id: 'split_lvl', name: 'Split Lvl', icon: Icons.stairs),
    RoomType(id: 'closet_rm', name: 'Closet Rm', icon: Icons.door_sliding),
    RoomType(id: 'powder_rm', name: 'Powder Rm', icon: Icons.wash),
    RoomType(id: 'laundry_rm', name: 'Laundry Rm', icon: Icons.local_laundry_service),
    RoomType(id: 'master_br', name: 'Master Br', icon: Icons.bedroom_parent),
    RoomType(id: 'study_rm', name: 'Study Rm', icon: Icons.menu_book),
    RoomType(id: 'family_rm', name: 'Family Rm', icon: Icons.family_restroom),
    RoomType(id: 'foyer', name: 'Foyer', icon: Icons.door_front_door),
    RoomType(id: 'entry', name: 'Entry', icon: Icons.meeting_room),
    RoomType(id: 'breakfast_rm', name: 'Breakfast Rm', icon: Icons.free_breakfast),
    RoomType(id: 'utility_rm', name: 'Utility Rm', icon: Icons.build),
    RoomType(id: 'pantry_rm', name: 'Pantry Rm', icon: Icons.shelves),
    RoomType(id: 'stairway', name: 'Stairway', icon: Icons.stairs_outlined),
    RoomType(id: 'garage', name: 'Garage', icon: Icons.garage),
    RoomType(id: 'patio', name: 'Patio', icon: Icons.deck),
    RoomType(id: 'office', name: 'Office', icon: Icons.computer),
    RoomType(id: 'guest_rm', name: 'Guest Rm', icon: Icons.person),
  ];
}
