import { BusinessInformationForm } from "@/features/business-information/components/business-information-form";

export default function Home() {
  return (
    <main className="min-h-screen bg-background p-8">
      <div className="mx-auto max-w-4xl">
        <BusinessInformationForm />
      </div>
    </main>
  );
}