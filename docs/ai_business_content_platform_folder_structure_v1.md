# AI-Powered Business Content Automation Platform
## Professional Folder Structure (Version 1)

## Technology Stack
- Next.js 15 (App Router)
- React
- TypeScript
- Tailwind CSS
- shadcn/ui
- Supabase
- GroqCloud
- Google AI Studio (optional image enhancement)

---

# 1. Complete Project Folder Tree

```text
ai-business-content-platform/
├── app/
│   ├── (dashboard)/
│   │   ├── projects/
│   │   │   ├── page.tsx
│   │   │   └── [projectId]/
│   │   │       ├── page.tsx
│   │   │       ├── loading.tsx
│   │   │       └── error.tsx
│   │   └── layout.tsx
│   ├── api/
│   │   ├── projects/
│   │   │   ├── route.ts
│   │   │   └── [projectId]/route.ts
│   │   ├── workflow/
│   │   │   ├── generate/route.ts
│   │   │   └── [workflowRunId]/route.ts
│   │   ├── assets/upload/route.ts
│   │   └── exports/[exportFileId]/route.ts
│   ├── globals.css
│   ├── layout.tsx
│   └── page.tsx
│
├── components/
│   ├── ui/
│   ├── forms/
│   │   ├── business-information-form.tsx
│   │   └── content-selection-form.tsx
│   ├── dashboard/
│   ├── outputs/
│   └── shared/
│
├── features/
│   ├── business-information/
│   │   ├── validators.ts
│   │   ├── transformers.ts
│   │   └── types.ts
│   ├── content-selection/
│   │   ├── validators.ts
│   │   ├── defaults.ts
│   │   └── types.ts
│   ├── prompt-builder/
│   │   ├── builder.ts
│   │   ├── template-loader.ts
│   │   └── types.ts
│   ├── ai-content-generation/
│   │   ├── groq-service.ts
│   │   ├── gemini-service.ts
│   │   └── types.ts
│   ├── poster-generation/
│   │   ├── renderer.ts
│   │   ├── templates.ts
│   │   └── types.ts
│   ├── output-formatting/
│   │   ├── formatter.ts
│   │   └── types.ts
│   ├── export/
│   │   ├── pdf-exporter.ts
│   │   ├── zip-exporter.ts
│   │   └── types.ts
│   ├── project-storage/
│   │   ├── repositories.ts
│   │   └── types.ts
│   └── workflow-orchestrator/
│       ├── orchestrator.ts
│       ├── progress.ts
│       └── types.ts
│
├── lib/
│   ├── supabase/
│   │   ├── client.ts
│   │   ├── server.ts
│   │   └── storage.ts
│   ├── ai/
│   │   ├── groq.ts
│   │   └── gemini.ts
│   ├── export/
│   │   ├── pdf.ts
│   │   └── zip.ts
│   ├── utils/
│   │   ├── slug.ts
│   │   ├── dates.ts
│   │   ├── file.ts
│   │   └── logger.ts
│   ├── constants/
│   │   ├── business-types.ts
│   │   ├── content-types.ts
│   │   └── statuses.ts
│   └── validations/
│       └── common.ts
│
├── prompts/
│   ├── text/
│   │   ├── reel-script.md
│   │   ├── caption.md
│   │   └── hashtags.md
│   ├── visual/
│   │   ├── poster.md
│   │   └── background-image.md
│   └── planning/
│       └── content-calendar.md
│
├── templates/
│   ├── posters/
│   │   ├── gym/
│   │   ├── salon/
│   │   └── clinic/
│   └── exports/
│
├── types/
│   ├── database.ts
│   ├── project.ts
│   ├── workflow.ts
│   ├── content.ts
│   └── api.ts
│
├── database/
│   ├── schema/
│   │   └── ai_business_content_platform_schema_v1.sql
│   ├── migrations/
│   └── seeds/
│
├── public/
│   ├── placeholder-images/
│   └── icons/
│
├── tests/
│   ├── unit/
│   ├── integration/
│   └── fixtures/
│
├── .env.local
├── components.json
├── next.config.ts
├── package.json
├── tailwind.config.ts
├── tsconfig.json
└── README.md
```

---

# 2. Purpose of Each Folder

## app/
Contains Next.js App Router pages, layouts, and API routes.

## components/
Reusable React UI components.

## features/
Business logic organized by module. Each feature is self-contained.

## lib/
Shared infrastructure code, utilities, and integrations.

## prompts/
Prompt templates used by the Prompt Builder Module.

## templates/
HTML/CSS poster and export templates.

## types/
Global TypeScript interfaces and types.

## database/
SQL schema, migrations, and seed files.

## tests/
Unit and integration tests.

---

# 3. Recommended Naming Conventions

- Folders: kebab-case
- React components: PascalCase exports, kebab-case filenames
- Utility files: kebab-case
- Type files: singular nouns where practical
- Constants: UPPER_SNAKE_CASE values
- SQL files: snake_case

Examples:
- business-information-form.tsx
- workflow-orchestrator/
- ai_business_content_platform_schema_v1.sql

---

# 4. Placement of SQL Schema Files

Store all database assets under:

```text
database/
├── schema/
├── migrations/
└── seeds/
```

Primary schema file:

```text
database/schema/ai_business_content_platform_schema_v1.sql
```

---

# 5. API Route Organization

## Project APIs
- GET /api/projects
- POST /api/projects
- GET /api/projects/[projectId]

## Workflow APIs
- POST /api/workflow/generate
- GET /api/workflow/[workflowRunId]

## Asset APIs
- POST /api/assets/upload

## Export APIs
- GET /api/exports/[exportFileId]

---

# 6. Service Layer Structure

Feature modules contain domain-specific services.

Examples:
- features/prompt-builder/builder.ts
- features/ai-content-generation/groq-service.ts
- features/workflow-orchestrator/orchestrator.ts

Shared provider wrappers live in `lib/`.

---

# 7. Type Definitions

Global shared types are stored in:

```text
types/
```

Examples:
- database.ts
- project.ts
- workflow.ts
- content.ts
- api.ts

Feature-specific types stay inside each feature folder.

---

# 8. Utility Libraries

Utilities are stored in:

```text
lib/utils/
```

Examples:
- dates.ts
- slug.ts
- file.ts
- logger.ts

Validation helpers:
```text
lib/validations/
```

---

# 9. Prompt Templates Storage

All prompt templates are stored as Markdown files:

```text
prompts/
├── text/
├── visual/
└── planning/
```

Benefits:
- Easy to edit without changing code
- Version controllable
- Reusable across modules

---

# 10. Best Practices for Scalability and Maintainability

1. Organize business logic by feature.
2. Keep UI and business logic separate.
3. Store prompts as external templates.
4. Use TypeScript interfaces for all data contracts.
5. Use Supabase as the unified backend.
6. Use JSONB for flexible metadata.
7. Keep API routes thin and delegate to services.
8. Centralize shared utilities and constants.
9. Write tests for validators and orchestrator logic.
10. Treat `features/` as the core application domain.

---

# Recommended Development Order

1. Initialize Next.js project
2. Configure Tailwind CSS and shadcn/ui
3. Set up Supabase
4. Import SQL schema
5. Create folder structure
6. Build Business Information Module
7. Build Content Selection Module
8. Build Prompt Builder
9. Build AI Content Generation
10. Build Workflow Orchestrator
11. Add Output Formatting and Export
12. Add Poster Generation

---

# Final Architectural Summary

This folder structure is:

- Modular
- Production-ready
- Easy to maintain
- Scalable to SaaS
- Fully aligned with Version 1 requirements
- Compatible with zero-cost deployment using Supabase and Vercel
