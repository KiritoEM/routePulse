// vehicle.repository.ts
import { Inject, Injectable } from "@nestjs/common";
import { eq } from "drizzle-orm";
import { Vehicle, vehicles } from "src/common/drizzle/schemas";
import * as drizzleProvider from "src/common/drizzle/drizzle.provider";
import { DRIZZLE_PROVIDER_KEY } from "src/core/constants/dependencies-constants";
import { CreateVehicleSchema, UpdateVehicleSchema } from "./types";

@Injectable()
export class VehicleRepository {
  constructor(
    @Inject(DRIZZLE_PROVIDER_KEY)
    private readonly db: drizzleProvider.DrizzleDB,
  ) {}

  async findById(id: string): Promise<Vehicle | null> {
    const result = await this.db.query.vehicles.findFirst({
      where: eq(vehicles.id, id),
    });
    return result ?? null;
  }

  async create(data: CreateVehicleSchema): Promise<Vehicle | null> {
    const result = await this.db.insert(vehicles).values(data).returning();
    return result[0] ?? null;
  }

  async findAll(userId: string): Promise<Vehicle[]> {
    return this.db.query.vehicles.findMany({
      where: eq(vehicles.userId, userId),
    });
  }

  async update(id: string, data: UpdateVehicleSchema): Promise<Vehicle | null> {
    const result = await this.db
      .update(vehicles)
      .set(data)
      .where(eq(vehicles.id, id))
      .returning();
    return result[0] ?? null;
  }
}
