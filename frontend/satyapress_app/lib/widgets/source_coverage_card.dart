import 'package:flutter/material.dart';

/// A card detailing the specific news sources that are covering and ignoring a story.
class SourceCoverageCard extends StatelessWidget {
  final List<String> sourcesCovering;
  final List<String> sourcesIgnoring;

  const SourceCoverageCard({
    super.key,
    required this.sourcesCovering,
    required this.sourcesIgnoring,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.source_rounded,
                  size: 20.0,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8.0),
                Text(
                  'Media Coverage Audit',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Main layout (Responsive Row/Column)
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 500;

                final coveringList = _buildSourceList(
                  context,
                  title: 'Covering Outlets',
                  sources: sourcesCovering,
                  isCovering: true,
                  icon: Icons.check_circle_rounded,
                  color: const Color(0xFF10B981), // Neutral soft green
                );

                final ignoringList = _buildSourceList(
                  context,
                  title: 'Ignoring Outlets',
                  sources: sourcesIgnoring,
                  isCovering: false,
                  icon: Icons.cancel_rounded,
                  color: const Color(0xFFEF4444), // Neutral soft red
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: coveringList),
                      const SizedBox(width: 16.0),
                      Expanded(child: ignoringList),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      coveringList,
                      const SizedBox(height: 20.0),
                      ignoringList,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceList(
    BuildContext context, {
    required String title,
    required List<String> sources,
    required bool isCovering,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // List Title Header
        Row(
          children: [
            Icon(icon, size: 16.0, color: color),
            const SizedBox(width: 6.0),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),

        // List Elements
        if (sources.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 22.0),
            child: Text(
              'No outlets verified.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sources.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              final source = sources[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: color.withValues(alpha: 0.15),
                    width: 1.0,
                  ),
                ),
                child: Text(
                  source,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
