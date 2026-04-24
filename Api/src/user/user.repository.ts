import { users } from "../common/drizzle/schemas/user.schema";
import { and, eq, SQL } from "drizzle-orm";
import { Inject, Injectable } from "@nestjs/common";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import { CreateUserSchema, UpdateUserSchema } from "./types";
import { User } from "src/common/drizzle/schemas";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

@Injectable()
export class UserRepository {
  private readonly commonConditions: SQL[] = [eq(users.isDeleted, false)];

  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY)
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  async create(data: CreateUserSchema): Promise<User[]> {
    return await this.db.insert(users).values(data).returning();
  }

  async findById(id: string) {
    return (
      (await this.db.query.users.findFirst({
      where: and(eq(users.id, id), ...this.commonConditions),
        with: { profilePicture: true },
      })) ?? null
    );
  }

  async findByEmail(email: string) {
    return (
      (await this.db.query.users.findFirst({
        where: and(eq(users.email, email), ...this.commonConditions),
        with: { profilePicture: true },
      })) ?? null
    );
  }

  async findByRefreshToken(refreshToken: string) {
    return (
      (await this.db.query.users.findFirst({
        where: and(
          eq(users.refreshToken, refreshToken),
          ...this.commonConditions,
        ),
      })) ?? null
    );
  }

  async update(id: string, data: UpdateUserSchema) {
    return await this.db
      .update(users)
      .set(data)
      .where(eq(users.id, id))
      .returning();
  }

  async delete(userId: string): Promise<void> {
    await this.db.delete(users).where(eq(users.id, userId));
  }
}
