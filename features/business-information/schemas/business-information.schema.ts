import { z } from "zod";

export const businessInformationSchema = z.object({
  businessName: z.string().min(2, "Business name must be at least 2 characters."),
  businessType: z.string().min(1, "Business type is required."),
  businessDescription: z.string().optional(),

  targetAudience: z.string().min(2, "Target audience is required."),
  targetLocation: z.string().optional(),

  marketingGoal: z.string().min(1, "Marketing goal is required."),
  campaignType: z.string().optional(),

  brandTone: z.string().optional(),
  preferredLanguage: z.string().min(1, "Preferred language is required."),
  brandColors: z.array(z.string()).optional(),

  offerTitle: z.string().optional(),
  offerDetails: z.string().optional(),
  offerValidUntil: z.string().optional(),
  callToAction: z.string().optional(),

  websiteUrl: z
    .string()
    .url("Please enter a valid website URL.")
    .optional()
    .or(z.literal("")),
});

export type BusinessInformationSchema = z.infer<
  typeof businessInformationSchema
>;