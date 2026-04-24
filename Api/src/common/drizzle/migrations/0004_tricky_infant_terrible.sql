ALTER TABLE "deliveries" DROP CONSTRAINT "deliveries_client_id_clients_id_fk";
--> statement-breakpoint
ALTER TABLE "clients" ADD COLUMN "client_location" double precision[] NOT NULL;--> statement-breakpoint
ALTER TABLE "clients" ADD COLUMN "encrypted_key" text;--> statement-breakpoint
ALTER TABLE "clients" ADD COLUMN "is_deleted" boolean DEFAULT false;--> statement-breakpoint
ALTER TABLE "clients" ADD COLUMN "deleted_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "deliveries" ADD CONSTRAINT "deliveries_client_id_clients_id_fk" FOREIGN KEY ("client_id") REFERENCES "public"."clients"("id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "clients" DROP COLUMN "delivery_location";