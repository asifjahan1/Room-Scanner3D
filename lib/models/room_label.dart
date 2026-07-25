import 'package:flutter/material.dart';

class RoomLabelPreset {
  final String id;
  final String name;
  final IconData icon;

  const RoomLabelPreset({
    required this.id,
    required this.name,
    required this.icon,
  });

  static const List<RoomLabelPreset> presets = [
    RoomLabelPreset(id: 'primary_suite', name: 'Primary Suite', icon: Icons.king_bed),
    RoomLabelPreset(id: 'main_br', name: 'Main Br', icon: Icons.bed),
    RoomLabelPreset(id: 'bath_1', name: 'Bath #1', icon: Icons.bathtub),
    RoomLabelPreset(id: 'bath_2', name: 'Bath #2', icon: Icons.bathtub_outlined),
    RoomLabelPreset(id: 'kitchen', name: 'Kitchen', icon: Icons.kitchen),
    RoomLabelPreset(id: 'living_rm', name: 'Living Rm', icon: Icons.weekend),
    RoomLabelPreset(id: 'dining_rm', name: 'Dining Rm', icon: Icons.dining),
    RoomLabelPreset(id: 'split_lvl', name: 'Split Lvl', icon: Icons.stairs),
    RoomLabelPreset(id: 'closet_rm', name: 'Closet Rm', icon: Icons.door_sliding),
    RoomLabelPreset(id: 'powder_rm', name: 'Powder Rm', icon: Icons.wash),
    RoomLabelPreset(id: 'laundry_rm', name: 'Laundry Rm', icon: Icons.local_laundry_service),
    RoomLabelPreset(id: 'master_br', name: 'Master Br', icon: Icons.bedroom_parent),
    RoomLabelPreset(id: 'study_rm', name: 'Study Rm', icon: Icons.menu_book),
    RoomLabelPreset(id: 'family_rm', name: 'Family Rm', icon: Icons.family_restroom),
    RoomLabelPreset(id: 'foyer', name: 'Foyer', icon: Icons.door_front_door),
    RoomLabelPreset(id: 'entry', name: 'Entry', icon: Icons.meeting_room),
    RoomLabelPreset(id: 'breakfast_rm', name: 'Breakfast Rm', icon: Icons.free_breakfast),
    RoomLabelPreset(id: 'utility_rm', name: 'Utility Rm', icon: Icons.build),
    RoomLabelPreset(id: 'pantry_rm', name: 'Pantry Rm', icon: Icons.shelves),
    RoomLabelPreset(id: 'stairway', name: 'Stairway', icon: Icons.stairs_outlined),
    RoomLabelPreset(id: 'garage', name: 'Garage', icon: Icons.garage),
    RoomLabelPreset(id: 'patio', name: 'Patio', icon: Icons.deck),
    RoomLabelPreset(id: 'office', name: 'Office', icon: Icons.computer),
    RoomLabelPreset(id: 'guest_rm', name: 'Guest Rm', icon: Icons.person),
  ];
}
