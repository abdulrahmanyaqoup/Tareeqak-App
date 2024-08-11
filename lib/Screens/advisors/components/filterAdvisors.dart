import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/models.dart';
import '../../../provider/universityProvider.dart';
import '../../../widgets/customButton.dart';
import '../../university/components/bottomSheet.dart';

class FilterAdvisors extends ConsumerStatefulWidget {
  const FilterAdvisors({
    required this.onFilterChanged,
    required this.onClearFilters,
    super.key,
  });

  final void Function(String? university, String? school, String? major)
      onFilterChanged;
  final VoidCallback onClearFilters;

  @override
  ConsumerState<FilterAdvisors> createState() => _FilterAdvisorsState();
}

class _FilterAdvisorsState extends ConsumerState<FilterAdvisors> {
  String? selectedUniversity;
  String? selectedSchool;
  String? selectedMajor;

  @override
  Widget build(BuildContext context) {
    final universityState = ref.watch(universityProvider).value!;

    final universities = universityState.universities.uniqueByName().toList();
    var schools = <School>[];
    var majors = <Major>[];

    if (selectedUniversity != null) {
      final university =
          universities.firstWhereOrNull((u) => u.name == selectedUniversity);
      if (university != null) {
        schools = university.schools.uniqueByName().toList();
        final school = selectedSchool != null
            ? schools.firstWhereOrNull((s) => s.name == selectedSchool)
            : null;
        majors = school != null
            ? school.majors.uniqueByName().toList()
            : schools.expand((s) => s.majors).uniqueByName().toList();
      }
    } else {
      schools = universityState.schools.uniqueByName().toList();
      majors = universityState.majors.uniqueByName().toList();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          if (selectedUniversity != null ||
              selectedSchool != null ||
              selectedMajor != null)
            CustomButton(
              onPressed: () {
                setState(() {
                  selectedUniversity = null;
                  selectedSchool = null;
                  selectedMajor = null;
                  widget.onClearFilters();
                });
              },
              text: 'Clear Filters',
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildDropdown<void>(
                context,
                'University',
                selectedUniversity,
                universities,
                onSelected: (value) {
                  setState(() {
                    selectedUniversity = value;
                    widget.onFilterChanged(
                      selectedUniversity,
                      selectedSchool,
                      selectedMajor,
                    );
                  });
                },
              ),
              const SizedBox(width: 8),
              _buildDropdown<void>(
                context,
                'School',
                selectedSchool,
                schools,
                onSelected: (value) {
                  setState(() {
                    selectedSchool = value;
                    widget.onFilterChanged(
                      selectedUniversity,
                      selectedSchool,
                      selectedMajor,
                    );
                  });
                },
              ),
              const SizedBox(width: 8),
              _buildDropdown<void>(
                context,
                'Major',
                selectedMajor,
                majors,
                onSelected: (value) {
                  setState(() {
                    selectedMajor = value;
                    widget.onFilterChanged(
                      selectedUniversity,
                      selectedSchool,
                      selectedMajor,
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>(
    BuildContext context,
    String title,
    String? selectedValue,
    List<dynamic> items, {
    required ValueChanged<String?> onSelected,
    bool enabled = true,
  }) {
    return Expanded(
      child: InkWell(
        onTap: enabled
            ? () => showModalBottomSheet<String>(
                  context: context,
                  builder: (context) => GridModalBottomSheet(
                    title: 'Filter by $title',
                    noRoute: true,
                    items: items,
                  ),
                ).then((selectedValue) {
                  if (selectedValue != null) {
                    onSelected(selectedValue);
                  }
                })
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  selectedValue ?? title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}

extension UniqueByName<T> on Iterable<T> {
  Iterable<T> uniqueByName() {
    final names = <String>{};
    return where((element) {
      final name = (element as dynamic).name as String;
      if (names.contains(name)) {
        return false;
      } else {
        names.add(name);
        return true;
      }
    });
  }
}
