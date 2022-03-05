CREATE TABLE "accounts" (
  "id" bigserial PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar NOT NULL,
  "email_address" varchar NOT NULL,
  "gender" varchar NOT NULL,
  "age" int NOT NULL,
  "height" int NOT NULL,
  "current_weight" int NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "foodlog" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint NOT NULL,
  "calories" int NOT NULL,
  "protein" int NOT NULL,
  "fat" int NOT NULL,
  "carbs" int NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "exercise" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint,
  "start_time" timestamptz DEFAULT (now()),
  "stop_time" timestamptz DEFAULT (now()),
  "type" varchar,
  "calories_burned" int,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

CREATE TABLE "macros" (
  "id" bigserial PRIMARY KEY,
  "account_id" bigint,
  "protein" int NOT NULL,
  "fats" int NOT NULL,
  "carbs" int NOT NULL,
  "calories" int NOT NULL,
  "created_at" timestamptz NOT NULL DEFAULT (now())
);

ALTER TABLE "foodlog" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");

ALTER TABLE "exercise" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");

ALTER TABLE "macros" ADD FOREIGN KEY ("account_id") REFERENCES "accounts" ("id");

CREATE INDEX ON "accounts" ("email_address");

CREATE INDEX ON "foodlog" ("account_id");

CREATE INDEX ON "exercise" ("account_id");

CREATE INDEX ON "macros" ("account_id");

COMMENT ON COLUMN "accounts"."age" IS 'must be positive';

COMMENT ON COLUMN "accounts"."height" IS 'must be positive';

COMMENT ON COLUMN "accounts"."current_weight" IS 'must be positive';

COMMENT ON COLUMN "foodlog"."calories" IS 'must be positive';

COMMENT ON COLUMN "foodlog"."protein" IS 'must be positive';

COMMENT ON COLUMN "foodlog"."fat" IS 'must be positive';

COMMENT ON COLUMN "foodlog"."carbs" IS 'must be positive';

COMMENT ON COLUMN "exercise"."calories_burned" IS 'must be positive';

COMMENT ON COLUMN "macros"."protein" IS 'must be positive';

COMMENT ON COLUMN "macros"."fats" IS 'must be positive';

COMMENT ON COLUMN "macros"."carbs" IS 'must be positive';

COMMENT ON COLUMN "macros"."calories" IS 'must be positive';
