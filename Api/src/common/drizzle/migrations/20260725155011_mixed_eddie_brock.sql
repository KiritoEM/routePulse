ALTER TABLE "vehicles" ADD COLUMN "is_deleted" boolean DEFAULT false;--> statement-breakpoint
ALTER TABLE "vehicles" ADD COLUMN "deleted_at" timestamp with time zone;