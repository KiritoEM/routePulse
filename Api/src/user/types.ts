import { User } from "src/common/drizzle/schemas";

export type CreateUserSchema = Pick<
  User,
  "fullName" | "email" | "password" | "refreshToken" | "biometricEnabled"
>;

export type UpdateUserSchema = Partial<
  Pick<User, "fullName" | "refreshToken" | "password" | "isDeleted">
>;
