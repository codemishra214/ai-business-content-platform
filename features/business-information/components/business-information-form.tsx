"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";

import { businessInformationSchema } from "../schemas/business-information.schema";
import type { BusinessInformationSchema } from "../schemas/business-information.schema";

export function BusinessInformationForm() {
  const form = useForm<BusinessInformationSchema>({
    resolver: zodResolver(businessInformationSchema),
    defaultValues: {
      businessName: "",
      businessType: "",
      businessDescription: "",
      targetAudience: "",
      targetLocation: "",
      marketingGoal: "",
      preferredLanguage: "English",
      offerTitle: "",
      offerDetails: "",
      callToAction: "",
      websiteUrl: "",
    },
  });

  const onSubmit = (data: BusinessInformationSchema) => {
    console.log("Business Information:", data);
    alert("Form submitted successfully! Check the browser console.");
  };

  return (
    <form onSubmit={form.handleSubmit(onSubmit)}>
      <h1 className="text-3xl font-bold">
        Business Information Form
      </h1>
      <p className="text-muted-foreground mt-2">
        Form UI implementation begins in the next step.
      </p>

      <button
        type="submit"
        className="mt-6 rounded-md bg-black px-4 py-2 text-white"
      >
        Test Submit
      </button>
    </form>
  );
}