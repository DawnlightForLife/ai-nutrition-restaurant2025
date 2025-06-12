# Contact Certification Feature

## Overview

The Contact Certification feature provides a streamlined way for users to contact customer service for merchant and nutritionist certification when the system is configured for manual review mode.

## User Flow

1. User clicks on certification button (merchant or nutritionist)
2. System checks configuration mode
3. If mode is "contact", navigates to contact page
4. User sees QR code and contact information
5. User contacts customer service through preferred method

## Components

### Contact Certification Page
- **File**: `lib/features/certification/presentation/pages/contact_certification_page.dart`
- **Features**:
  - QR code display for WeChat contact
  - Multiple contact methods (phone, email, WeChat)
  - Process explanation
  - Dynamic contact information from backend

### Integration Points

1. **User Profile Page**:
   - Checks certification mode
   - Routes to contact page when mode is "contact"
   - Maintains existing auto-certification flow when mode is "auto"

2. **System Configuration**:
   - Reads contact information from backend
   - Supports dynamic updates without app changes

## Backend Configuration

The following system configuration keys control contact information:

- `certification_contact_wechat`: WeChat ID for customer service
- `certification_contact_phone`: Phone number for customer service  
- `certification_contact_email`: Email address for certification inquiries

## Dependencies

- `qr_flutter`: For generating QR codes
- `url_launcher`: For launching phone and email apps

## Future Enhancements

1. **Multiple Language Support**: Add localization for contact page
2. **Dynamic QR Code Content**: Support different QR code types (WhatsApp, Telegram, etc.)
3. **Appointment Scheduling**: Allow users to schedule certification appointments
4. **Upload Documents**: Enable document upload for pre-review