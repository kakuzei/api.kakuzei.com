CREATE TABLE "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "settings" ("lock" varchar DEFAULT 'X', "path" varchar NOT NULL);
CREATE UNIQUE INDEX "index_settings_on_lock" ON "settings" ("lock");
CREATE TABLE "pictures" ("id" uuid NOT NULL PRIMARY KEY, "code" varchar NOT NULL, "name" varchar NOT NULL, "date_taken" datetime NOT NULL, "low_density_checksum" varchar NOT NULL, "high_density_checksum" varchar);
CREATE UNIQUE INDEX "index_pictures_on_date_taken" ON "pictures" ("date_taken");
CREATE UNIQUE INDEX "index_pictures_on_low_density_checksum" ON "pictures" ("low_density_checksum");
CREATE UNIQUE INDEX "index_pictures_on_high_density_checksum" ON "pictures" ("high_density_checksum");
CREATE TABLE "tags" ("id" uuid NOT NULL PRIMARY KEY, "name" varchar NOT NULL);
CREATE UNIQUE INDEX "index_tags_on_name" ON "tags" ("name");
CREATE TABLE "pictures_tags" ("tag_id" varchar, "picture_id" varchar);
CREATE INDEX "index_pictures_tags_on_tag_id" ON "pictures_tags" ("tag_id");
CREATE INDEX "index_pictures_tags_on_picture_id" ON "pictures_tags" ("picture_id");
INSERT INTO "schema_migrations" (version) VALUES
('20170101000000');


