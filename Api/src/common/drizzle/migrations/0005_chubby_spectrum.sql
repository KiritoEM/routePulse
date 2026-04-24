ALTER TABLE "files" ALTER COLUMN "delivery_item_id" DROP NOT NULL;--> statement-breakpoint
ALTER TABLE "users" ADD COLUMN "profile_picture_id" uuid;