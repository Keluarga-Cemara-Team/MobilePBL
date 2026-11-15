import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/app_scale.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/assessment_colors.dart';
import '../../domain/entities/psychologist.dart';
import '../../domain/utils/geo_calculator.dart';

class PsychologistCard extends StatelessWidget {
  const PsychologistCard({
    super.key,
    required this.psychologist,
  });

  final Psychologist psychologist;

  Future<void> _openGoogleMaps() async {
    final lat = psychologist.latitude;
    final lng = psychologist.longitude;
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _openWhatsApp() async {
    if (psychologist.whatsapp.isEmpty) return;
    final text = Uri.encodeComponent(
      'Halo ${psychologist.name}, saya ingin membuat janji konsultasi psikologi.',
    );
    final url = 'https://wa.me/${psychologist.whatsapp}?text=$text';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callPhone() async {
    if (psychologist.phone.isEmpty) return;
    final uri = Uri.parse('tel:${psychologist.phone}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final distanceText = psychologist.distanceKm != null
        ? GeoCalculator.formatDistance(psychologist.distanceKm!)
        : null;

    return Container(
      margin: EdgeInsets.only(bottom: context.ui(AppSpacing.md)),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(context.ui(16)),
        border: Border.all(color: colors.border.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(context.ui(AppSpacing.md)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar / Icon
                Container(
                  width: context.ui(46),
                  height: context.ui(46),
                  decoration: BoxDecoration(
                    color: colors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(context.ui(12)),
                  ),
                  child: Icon(
                    Icons.psychology_outlined,
                    color: colors.primary,
                    size: context.ui(26),
                  ),
                ),
                SizedBox(width: context.ui(AppSpacing.sm)),
                // Info Nama & Klinik
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        psychologist.name,
                        style: TextStyle(
                          fontSize: context.ui(15),
                          fontWeight: FontWeight.bold,
                          color: colors.navy,
                        ),
                      ),
                      SizedBox(height: context.ui(2)),
                      Text(
                        psychologist.title,
                        style: TextStyle(
                          fontSize: context.ui(12),
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: context.ui(2)),
                      Text(
                        psychologist.clinicOrHospital,
                        style: TextStyle(
                          fontSize: context.ui(12),
                          color: colors.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: context.ui(AppSpacing.sm)),

            // Baris Rating & Jarak
            Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  color: Colors.amber.shade700,
                  size: context.ui(18),
                ),
                SizedBox(width: context.ui(4)),
                Text(
                  '${psychologist.rating} (${psychologist.reviewCount} ulasan)',
                  style: TextStyle(
                    fontSize: context.ui(12),
                    fontWeight: FontWeight.w600,
                    color: colors.body,
                  ),
                ),
                if (distanceText != null) ...[
                  SizedBox(width: context.ui(AppSpacing.sm)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.ui(8),
                      vertical: context.ui(2),
                    ),
                    decoration: BoxDecoration(
                      color: colors.leaf.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(context.ui(20)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.near_me,
                          size: context.ui(11),
                          color: colors.leaf,
                        ),
                        SizedBox(width: context.ui(3)),
                        Text(
                          '$distanceText dari lokasimu',
                          style: TextStyle(
                            fontSize: context.ui(11),
                            fontWeight: FontWeight.w600,
                            color: colors.leaf,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: context.ui(AppSpacing.xs)),

            // Alamat & Jam Buka
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: context.ui(14),
                  color: colors.body.withOpacity(0.7),
                ),
                SizedBox(width: context.ui(4)),
                Expanded(
                  child: Text(
                    psychologist.address,
                    style: TextStyle(
                      fontSize: context.ui(12),
                      color: colors.body.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.ui(3)),
            Row(
              children: [
                Icon(
                  Icons.access_time_outlined,
                  size: context.ui(14),
                  color: colors.body.withOpacity(0.7),
                ),
                SizedBox(width: context.ui(4)),
                Text(
                  psychologist.openHours,
                  style: TextStyle(
                    fontSize: context.ui(11),
                    color: colors.body.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.ui(AppSpacing.sm)),

            // Chips Spesialisasi
            Wrap(
              spacing: context.ui(6),
              runSpacing: context.ui(4),
              children: psychologist.specialties.map((spec) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.ui(8),
                    vertical: context.ui(3),
                  ),
                  decoration: BoxDecoration(
                    color: AssessmentColors.relaxationTint.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(context.ui(8)),
                  ),
                  child: Text(
                    spec,
                    style: TextStyle(
                      fontSize: context.ui(10.5),
                      fontWeight: FontWeight.w500,
                      color: colors.navy,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: context.ui(AppSpacing.md)),

            // Tombol Aksi
            Row(
              children: [
                // Tombol Rute Maps
                Expanded(
                  flex: 3,
                  child: OutlinedButton.icon(
                    onPressed: _openGoogleMaps,
                    icon: Icon(Icons.directions, size: context.ui(15)),
                    label: Text(
                      'Peta',
                      style: TextStyle(fontSize: context.ui(12)),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.primary,
                      side: BorderSide(color: colors.primary),
                      padding: EdgeInsets.symmetric(vertical: context.ui(8)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.ui(10)),
                      ),
                    ),
                  ),
                ),
                if (psychologist.whatsapp.isNotEmpty) ...[
                  SizedBox(width: context.ui(AppSpacing.xs)),
                  Expanded(
                    flex: 4,
                    child: ElevatedButton.icon(
                      onPressed: _openWhatsApp,
                      icon: Icon(Icons.chat, size: context.ui(15)),
                      label: Text(
                        'WhatsApp',
                        style: TextStyle(
                          fontSize: context.ui(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: context.ui(8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(context.ui(10)),
                        ),
                      ),
                    ),
                  ),
                ],
                if (psychologist.phone.isNotEmpty) ...[
                  SizedBox(width: context.ui(AppSpacing.xs)),
                  InkWell(
                    onTap: _callPhone,
                    borderRadius: BorderRadius.circular(context.ui(10)),
                    child: Container(
                      padding: EdgeInsets.all(context.ui(8)),
                      decoration: BoxDecoration(
                        color: colors.blob,
                        borderRadius: BorderRadius.circular(context.ui(10)),
                        border: Border.all(color: colors.border.withOpacity(0.5)),
                      ),
                      child: Icon(
                        Icons.phone,
                        size: context.ui(16),
                        color: colors.navy,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
