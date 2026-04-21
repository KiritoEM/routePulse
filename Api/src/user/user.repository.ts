import { users } from "../common/drizzle/schemas/user.schema";
import { and, eq, getTableColumns, SQL } from "drizzle-orm";
import { Inject, Injectable } from "@nestjs/common";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import { CreateUserSchema, UpdateUserSchema } from "./types";
import { files, User } from "src/common/drizzle/schemas";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";

@Injectable()
export class UserRepository {
  private readonly findUserCommonConditions: SQL[] = [
    eq(users.isDeleted, false),
  ];

  private get userSelectShape() {
    return {
      ...getTableColumns(users),
      profilePicture: files,
    };
  }

  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY)
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  private baseUserQuery() {
    return this.db
      .select(this.userSelectShape)
      .from(users)
      .leftJoin(files, eq(files.userId, users.id));
  }

  async create(data: CreateUserSchema): Promise<User[]> {
    return await this.db.insert(users).values(data).returning();
  }

  async findById(id: string): Promise<User | null> {
    const result = await this.baseUserQuery().where(eq(users.id, id)).limit(1);

    return result[0] ?? null;
  }

  async findByEmail(email: string): Promise<User | null> {
    const result = await this.baseUserQuery()
      .where(and(eq(users.email, email), ...this.findUserCommonConditions))
      .limit(1);

    return result[0] ?? null;
  }

  async findByRefreshToken(refreshToken: string): Promise<User | null> {
    const result = await this.db
      .select(getTableColumns(users))
      .from(users)
      .where(
        and(
          eq(users.refreshToken, refreshToken),
          ...this.findUserCommonConditions,
        ),
      )
      .limit(1);

    return result[0] ?? null;
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
