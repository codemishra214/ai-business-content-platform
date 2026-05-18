export interface BusinessInformationFormData {
  businessName: string;
  businessType: string;
  businessDescription?: string;

  targetAudience: string;
  targetLocation?: string;

  marketingGoal: string;
  campaignType?: string;

  brandTone?: string;
  preferredLanguage: string;
  brandColors?: string[];

  offerTitle?: string;
  offerDetails?: string;
  offerValidUntil?: string;
  callToAction?: string;

  websiteUrl?: string;
}