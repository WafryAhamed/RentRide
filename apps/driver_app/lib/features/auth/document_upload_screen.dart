import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text('Manage Documents', style: AppTextStyles.heading4),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload and track the status of your required documents for driving with RentRide.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 24),
              
              _DocUploadItem(icon: Icons.badge, label: 'National ID Card', status: 'Verified', isVerified: true),
              _DocUploadItem(icon: Icons.card_membership, label: 'Driving License', status: 'Pending Review', isPending: true),
              _DocUploadItem(icon: Icons.car_rental, label: 'Vehicle Registration', status: 'Required'),
              _DocUploadItem(icon: Icons.security, label: 'Insurance Certificate', status: 'Optional'),
              
              const SizedBox(height: 32),
              RentRideButton(
                text: 'Submit for Review',
                gradient: AppColors.accentGradient,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Documents submitted for review!'), 
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocUploadItem extends StatelessWidget {
  final IconData icon; 
  final String label; 
  final String status;
  final bool isVerified;
  final bool isPending;
  
  const _DocUploadItem({
    required this.icon, 
    required this.label, 
    required this.status,
    this.isVerified = false,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.accent;
    if (isVerified) {
      statusColor = AppColors.success;
    } else if (isPending) statusColor = AppColors.warning;
    else if (status != 'Required') statusColor = AppColors.textMuted;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard, 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkBorder, style: BorderStyle.solid),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(label, style: AppTextStyles.labelLarge),
                Text(status, style: AppTextStyles.caption.copyWith(color: statusColor)),
              ]
            ),
          ),
          if (isVerified)
            const Icon(Icons.check_circle, color: AppColors.success)
          else if (isPending)
            const Icon(Icons.access_time_filled, color: AppColors.warning)
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15), 
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Upload', style: AppTextStyles.labelSmall.copyWith(color: AppColors.accent)),
            ),
        ],
      ),
    );
  }
}
